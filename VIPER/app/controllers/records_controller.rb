class RecordsController < ApplicationController
	def dist(point1, point2)
    d = 0
  	point1.each do |key,value|
  			d += (value - point2[key]).abs
    end  
    return d
  end

  def findClosestCentroid(centroids, user, k)
  	closest_centroid = 0	
    closest_dist = dist(user, centroids[0])
    for j in 1..(k-1)
      if dist(user, centroids[j]) < closest_dist
        closest_dist = dist(user, centroids[j])
        closest_centroid = j
      end
    end
		return closest_centroid
  end
	
  def addUserToCentroid(user, centroids, idx, number_of_users_in_centroid)
    newpoint = user
    centroids[idx].each_pair do |item, score|
    	centroids[idx][item] = 1.0 * (number_of_users_in_centroid * centroids[idx][item] + newpoint[item]) / (number_of_users_in_centroid + 1)
		end
  end

  def	removeUserFromCentroid(user, centroids, idx, number_of_users_in_centroid)
  	newpoint = user
    centroids[idx].each_pair do |item, score|
    	centroids[idx][item] = 1.0 * (@k * centroids[idx][item] - newpoint[item]) / (@k - 1)
    end
  end
 
  # converts a record to a hash
  def convertRecordToUser(record)
    record_json = record.to_json
    user = JSON.parse(record_json)
    user_modified = Hash.new
    user.each do |key,value|
      if (!!value == value)
        if value	
          user_modified[key] = 1
        else
          user_modified[key] = 0
        end
      end
    end
    return user_modified
  end

  def convertRecordToUserAr(record_ar)
    user_ar = Array.new()
    record_ar.each do |record|
      user_ar << convertRecordToUser(record)
    end
    return user_ar
  end

  def clusterUsers
    # extract records, and convert them to an array of hashes
    record_ar = Record.find(:all)
    user_ar = convertRecordToUserAr(record_ar)
    
    @n = user_ar.length 
    @m = 25 
    @k = 2
    @iter = 10

    total_distance_for_best_clustering = -1
    for iter_count in 1..@iter
      numbers = (0..(@n-1)).to_a.shuffle
	  end

    clusterID = Array.new(@n)
    clusters = Array.new(@k)
    centroids = Array.new(@k)

    # initialize the cluster centers as @k random points
    for i in 0..(@k-1)
      idx = numbers[i]
      clusters[i] = Array.new
      clusters[i] << idx
     
      centroids[i] = user_ar[idx] 
      clusterID[idx] = i 
    end

    for i in @k..(@n-1)
      idx = numbers[i]

      # for each other user, find the cluster center that is the closest
      closest_centroid = findClosestCentroid(centroids,	user_ar[idx], @k)

      addUserToCentroid(user_ar[idx], centroids, closest_centroid,
                        clusters[closest_centroid].length)
      
      clusters[closest_centroid] << idx
      clusterID[idx] = closest_centroid
    end

    steps_to_convergence = 0
    is_converged = false
    while !is_converged
      steps_to_convergence += 1
      is_converged = true

      for i in 0..(@n-1)
        current_centroid = clusterID[i]
        closest_centroid = findClosestCentroid(centroids, user_ar[i], @k)
        
        if closest_centroid != current_centroid
          is_converged = false
          # remove the user from the old cluster
          removeUserFromCentroid(user_ar[i], centroids,
                                 current_centroid,
                                 clusters[current_centroid].length)
          clusters[current_centroid].delete(i)

          # add the user to the new cluster
          addUserToCentroid(user_ar[i], centroids, closest_centroid,
                            clusters[closest_centroid].length)
          clusterID[i] = closest_centroid
          clusters[closest_centroid] << i
        end
      end
    end

    # Check if the current clustering yields a better result
    current_distance = 0
    for idx in 0..(@k-1)
      clusters[idx].each do |user_number|
        current_distance += Math.sqrt(dist(user_ar[user_number], centroids[idx]))
      end
    end

    if total_distance_for_best_clustering == -1 or total_distance_for_best_clustering > current_distance
      total_distance_for_best_clustering = current_distance
      best_clustering = clusters
    end
    
    # store the list of clusters: 
    # cluster[i]: list of indices for that cluster, 0 <= i < @k
    ClustersController.saveClusters(best_clustering, @k)

    # Generate the friends table
    friends_table = CloseRelationsController.findCloseRelations(
        best_clustering, user_ar, @n, @k)
    
    # return best_clustering
  	return friends_table 
  end

  # Aggregate his friends' data and output recommendation
  def getRecommendation(allrecords, friends)
  end

  # find the cluster that the new user belongs to
  def findClosestCluster(clusters, newuser, user_ar)
    # compute the centroids for all clusters
    max_num_clusters = 100 
    k = 0
    
    centroids = Array.new(max_num_clusters) 
    number_of_users_in_centroid = Array.new(max_num_clusters)
    number_of_users_in_centroid.fill(0, 0..(max_num_clusters-1))
    
    clusters.each do |cluster_pair|
      current_clusterid = cluster_pair[:clusterid]
      current_userid = cluster_pair[:userid]
      if number_of_users_in_centroid[current_clusterid] = 0
        centroids[current_clusterid] = user_ar[current_userid]
        if k < current_clusterid
          k = current_clusterid + 1
        end
      else
        addUserToCentroid(user_ar[current_userid], centroids, 
                          current_clusterid,
                          number_of_users_in_centroid[current_clusterid])
      end 
    end 
    closest_centroid = findClosestCentroid(centroids, newuser, k)
    return closest_centroid
  end
 
  def getRecommendations(newuser, user_ar, friends)
    @r = 5

    # For each feature, count the number of likes by the 
    # newuser's friends
    freq = Hash.new
    newuser.each do |key,value| 
      freq[key] = 0
      friends.each do |friendid|
       freq[key] += user_ar[friendid][key]
      end
    end

    pq = Containers::PriorityQueue.new
    newuser.each do |key,value|
      pq.push(key, freq[key])
    end

    # Add features to the recommendation list based on number of likes
    # Do not include features the newuser already likes
    recommendations = Array.new(@r)
    i = 0
    while i < @r
      bestfeature = pq.pop
      if freq[bestfeature] == 0
        for j in i..(@r-1)
          recommendations[j] = -1
        end
        break
      end
      if newuser[bestfeature] == 0
        recommendations[i] = bestfeature 
        i = i + 1
      end 
    end

    return recommendations  
  end

  # GET /records
  # GET /records.json
  def index
    @records = Record.all
    @clusters = clusterUsers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @records }
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
    @record = Record.find(params[:id])

    allrecords = Record.find(:all)

    user_ar = convertRecordToUserAr(allrecords)
    newuser = convertRecordToUser(@record)

    newuserid = user_ar.count - 1 
    
    # find the cluster that the new user belongs to
    # This is in the form pair(clusterid, userid)
    clusters = ClustersController.getClusters
    @clusterid = findClosestCluster(clusters, newuser, user_ar)
    ClustersController.saveNewUser(@clusterid, newuserid)

    # find friends for that user
    @friends = CloseRelationsController.getFriendsForNewUser(
        user_ar, newuser, newuserid, clusters, @clusterid)
    
    # Aggregate his friends' data and output recommendation
    @recommendations = getRecommendations(newuser, user_ar, @friends)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @record }
    end
  end

  # GET /records/new
  # GET /records/new.json
  def new
    @record = Record.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @record }
    end
  end

  # GET /records/1/edit
  def edit
    @record = Record.find(params[:id])
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(params[:record])
    
    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, :notice => 'Record was successfully created.' }
        format.json { render :json => @record, :status => :created, :location => @record }
      else
        format.html { render :action => "new" }
        format.json { render :json => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /records/1
  # PUT /records/1.json
  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        format.html { redirect_to @record, :notice => 'Record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @record.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end
end
