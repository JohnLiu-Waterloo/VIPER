require 'rubygems'
require 'algorithms'

class CloseRelationsController < ApplicationController
	
  def self.dist(point1, point2)
    d = 0
  	point1.each do |key,value|
  			d += (value - point2[key]).abs
    end  
    return d
  end

	def self.findCloseRelations(clusters, user_ar, n, k)
  	@n = n 
    @m = 25
    @k = k
    @f = 3
    
    distance_ar = Array.new(@n)
  	for i in 0..(@n-1)
  		distance_ar[i] = Array.new()
      for j in 0..(@n-1)
  			distance_ar[i] << dist(user_ar[i], user_ar[j])
  		end
    end

    # Clear the table in order to update relations list
    CloseRelation.destroy_all()

    # Find the close relations, and write them to the table
    friends = Array.new(@n)
  	for idx in 0..(@k-1)
  		cluster_size = clusters[idx].length

      for i in 0..(cluster_size-1)
  			current_user = clusters[idx][i]
        friends[current_user] = Array.new(@f)
  			
				# put everyone in the cluster into a priority queue
  			pq = Containers::PriorityQueue.new
        for j in 0..(cluster_size-1)
  				if i != j
          	pq.push(clusters[idx][j],
                    -1 * distance_ar[current_user][clusters[idx][j]])
  				end
        end

        for j in 0..(@f-1)
  				if pq.size < 1
            friends[current_user][j] = -1
          else
           	friends[current_user][j] = pq.pop
          end
        end
        CloseRelation.create(:userid => current_user,
                             :r0 => friends[current_user][0],
                             :r1 => friends[current_user][1],
                             :r2 => friends[current_user][2],
                             :r3 => friends[current_user][3],
                             :r4 => friends[current_user][4],
                             :r5 => friends[current_user][5],
                             :r6 => friends[current_user][6],
                             :r7 => friends[current_user][7],
                             :r8 => friends[current_user][8],
                             :r9 => friends[current_user][9])
   		end
    end
    return friends
  end 		

  def self.getFriendsForNewUser(user_ar, newuser, newuserid,
                                clusters, clusterid)
    @f = 3 
    friends = Array.new(@f)
    # put everyone in the cluster into a priority queue
    pq = Containers::PriorityQueue.new
    
    clusters.each do |cluster_pair| 
      if cluster_pair[:clusterid] == clusterid
        currentuser = cluster_pair[:userid]
        if currentuser != newuserid 
          pq.push(currentuser, -1*dist(newuser,user_ar[currentuser]))
        end
      end
    end
    
    for j in 0..(@f-1)
      if pq.size < 1
        friends[j] = -1
      else
        friends[j] = pq.pop
      end
    end
    CloseRelation.create(:userid => newuserid,
                         :r0 => friends[0],
                         :r1 => friends[1],
                         :r2 => friends[2],
                         :r3 => friends[3],
                         :r4 => friends[4],
                         :r5 => friends[5],
                         :r6 => friends[6],
                         :r7 => friends[7],
                         :r8 => friends[8],
                         :r9 => friends[9])
    return friends
  end

  def getFriendsForNewUser(allrecords, record, clusters, clusterid)
  end

  # GET /close_relations
  # GET /close_relations.json
  def index
    @close_relations = CloseRelation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @close_relations }
    end
  end

  # GET /close_relations/1
  # GET /close_relations/1.json
  def show
    @close_relation = CloseRelation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @close_relation }
    end
  end

  # GET /close_relations/new
  # GET /close_relations/new.json
  def new
    @close_relation = CloseRelation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @close_relation }
    end
  end

  # GET /close_relations/1/edit
  def edit
    @close_relation = CloseRelation.find(params[:id])
  end

  # POST /close_relations
  # POST /close_relations.json
  def create
    @close_relation = CloseRelation.new(params[:close_relation])

    respond_to do |format|
      if @close_relation.save
        format.html { redirect_to @close_relation, :notice => 'Close relation was successfully created.' }
        format.json { render :json => @close_relation, :status => :created, :location => @close_relation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @close_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /close_relations/1
  # PUT /close_relations/1.json
  def update
    @close_relation = CloseRelation.find(params[:id])

    respond_to do |format|
      if @close_relation.update_attributes(params[:close_relation])
        format.html { redirect_to @close_relation, :notice => 'Close relation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @close_relation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /close_relations/1
  # DELETE /close_relations/1.json
  def destroy
    @close_relation = CloseRelation.find(params[:id])
    @close_relation.destroy

    respond_to do |format|
      format.html { redirect_to close_relations_url }
      format.json { head :no_content }
    end
  end
end
