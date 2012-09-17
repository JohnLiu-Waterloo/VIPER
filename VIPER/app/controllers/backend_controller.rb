class BackendController < ApplicationController
  @n = 100
  @m = 50
  @k = 5
  @iter = 25

  def findClosestCentroid(centroids, user)
  	closest_centroid = 0	
    closest_dist = dist(user_ar[i], centroids[0])
    for j in 0..(@k-1)
      if dist(user_ar[i], centroids[j]) < closest_dist
        closest_dist = dist(user_ar[i], centroids[j])
        closest_centroid = j
      end
    end
		return closest_centroid
  end
	
  def addUserToCentroid(centroids, user, idx, number_of_users_in_centroid)
    newpoint = user
    newpoint.delete(timestamp)
    centroids[idx].each_pair do |item, score|
    	centroids[item] = 1.0 * (number_of_users_in_centroid * centroids[item] + newpoint[item]) / (number_of_users_in_centroid + 1)
		end
  end

  def	removeUserFromCentroid(centroids, current_centroid, user, number_of_users_in_centroid)
  	newpoint = user
    newpoint.delete(timestamp)
    centroids[idx].each_pair do |item, score|
    	centroids[item] = 1.0 * (@k * centroids[item] - newpoint[item]) / (@k - 1)
    end
  end
	
  def clusterUsers
    user_ar = Record.find(:all)
  	total_distance_for_best_clustering = -1

    @iter.times do
    	numbers = (0..(@n-1)).to_a.shuffle
		
      clusterID = Array.new(@n)
      clusters = Array.new(@k)
      centroids = Array.new(@k)

			# initialize the cluster centers as @k random points
     	for i in 0..(@k-1)
      	idx = numbers[i]
        clusters[i] = Array.new
        clusters[i] << idx
       
        centroids[i] = user_ar[0] 
  			centroids[i].delete(timestamp)      
        clusterID[i] = idx 
      end

      for i in @k..(@n-1)
      	idx = numbers[i]

				# for each other user, find the cluster center that is the closest
			  closest_centroid = findClosestCentroid(centroids,	user_ar[i])

  	    addUserToCentroid(centroids, closest_centroid, user_ar[i], clusters[closest_centroid].length)
        
        clusters[closest_centroid] << idx
        clusterID[i] = closest_centroid
			end

      steps_to_convergence = 0
      is_converged = false
      while !is_converged
      	steps_to_convergence++
				is_converged = true

        for i in 0..(@n-1)
  				current_centroid = clusterID[i]
          closest_centroid = findClosestCentroid(centroids, user_ar[i])
					
  				if closest != curCluster
          	is_converged = false
						# remove the user from the old cluster
  					removeUserFromCentroid(centroids, current_centroid, user_ar[i], clusters[closest_centroid].length)
						clusters[closest_centroid].delete(i)

						# add the user to the new cluster
            addUserToCentroid(centroids, closest_centroid, user_ar[i], clusters[closest_centroid].length)
            clusterID[i] = closest_centroid
            clusters[closest_centroid] << i
          end
        end
      end

      current_distance = 0
      for idx in 0..(@k-1)
  			clusters[idx].each do |user|
        	current_distance += sqrt(dist(user, centroids[idx]))
  			end
  		end

      if total_distance_for_best_clustering = -1 or total_distance_for_best_clustering > current_distance
      	total_distance_for_best_clustering = current_distance
				best_clustering = clusters
			end
    end
  end

  def findFriends
  end

  def getRecommendation
  end
end
