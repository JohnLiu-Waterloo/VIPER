class RecordsController < ApplicationController
	def dist(point1, point2)
    d = 0
  	point1.each do |key,value|
  			d += (value - point2[key]).abs
    end  
    return d
  end

  def findClosestCentroid(centroids, user)
  	closest_centroid = 0	
    closest_dist = dist(user, centroids[0])
    for j in 1..(@k-1)
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
	
  def clusterUsers
    @n = 3 
    @m = 25 
    @k = 2
    @iter = 1

    # extract records, and convert them to an array of hashes
    record_ar = Record.find(:all)
    user_ar = Array.new()
    record_ar.each do |record|
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
      user_ar << user_modified
    end
  	total_distance_for_best_clustering = -1

    for iter_count in 1..@iter
    	numbers = (0..(@n-1)).to_a.shuffle
		
      clusterID = Array.new(@n)
      clusters = Array.new(@k)
      centroids = Array.new(@k)

			# initialize the cluster centers as @k random points
     	for i in 0..(@k-1)
      	idx = numbers[i]
        clusters[i] = Array.new
        clusters[i] << idx
       
        centroids[i] = user_ar[i] 
        clusterID[i] = idx 
      end

      for i in @k..(@n-1)
      	idx = numbers[i]

				# for each other user, find the cluster center that is the closest
			  closest_centroid = findClosestCentroid(centroids,	user_ar[i])

  	    addUserToCentroid(user_ar[i], centroids, closest_centroid, clusters[closest_centroid].length)
        
        clusters[closest_centroid] << idx
        clusterID[i] = closest_centroid
			end

      steps_to_convergence = 0
      is_converged = false
      while !is_converged
      	steps_to_convergence += 1
				is_converged = true

        for i in 0..(@n-1)
  				current_centroid = clusterID[i]
          closest_centroid = findClosestCentroid(centroids, user_ar[i])
					
  				if closest_centroid != closest_centroid
          	is_converged = false
						# remove the user from the old cluster
  					removeUserFromCentroid(user_ar[i], centroids, current_centroid, clusters[closest_centroid].length)
						clusters[closest_centroid].delete(i)

						# add the user to the new cluster
            addUserToCentroid(user_ar[i], centroids, closest_centroid, clusters[closest_centroid].length)
            clusterID[i] = closest_centroid
            clusters[closest_centroid] << i
          end
        end
      end

      current_distance = 0
      for idx in 0..(@k-1)
  			clusters[idx].each do |user_number|
        	current_distance += Math.sqrt(dist(user_ar[user_number], centroids[idx]))
  			end
  		end

      if total_distance_for_best_clustering = -1 or total_distance_for_best_clustering > current_distance
      	total_distance_for_best_clustering = current_distance
				best_clustering = clusters
			end
    end
    friends_table = CloseRelationsController.findCloseRelations(best_clustering, user_ar)
     # return best_clustering
  	return friends_table
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
