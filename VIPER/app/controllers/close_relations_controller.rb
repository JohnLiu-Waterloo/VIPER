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
    @f = 1
    
    distance_ar = Array.new(@n)
  	for i in 0..(@n-1)
  		distance_ar[i] = Array.new()
      for j in 0..(@n-1)
  			distance_ar[i] << dist(user_ar[i], user_ar[j])
  		end
    end

    # Find the close relations
    friends = Array.new(@n)
  	for idx in 0..(@k-1)
  		cluster_size = clusters[idx].length

      for i in 0..(cluster_size-1)
  			current_user = clusters[idx][i]
        friends[current_user] = Array.new()
  			
				# put everyone in the cluster into a priority queue
  			pq = Containers::PriorityQueue.new
        for j in 0..(cluster_size-1)
  				if i != j
          	pq.push(clusters[idx][j],
                    dist(user_ar[current_user], user_ar[clusters[idx][j]]))
  				end
        end

        for j in 0..(@f-1)
  				if pq.size < 1
          	while j < @f
            	friends[current_user] << -1
              j += 1
            end
          else
           	friends[current_user] << pq.pop
          end
        end
   		end
    end
    return friends
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
