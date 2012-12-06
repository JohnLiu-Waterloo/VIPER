class ClustersController < ApplicationController
  # GET /clusters
  # GET /clusters.json
  
  def self.saveClusters(clusters, k)
    Cluster.destroy_all() 
    for idx in 0..(k-1)
      clusters[idx].each do |user_member|
        Cluster.create(:clusterid => idx,
                       :userid => user_member)
      end
    end
  end

  def self.saveNewUser(clusterid, newuserid)
    Cluster.create(:clusterid => clusterid,
                   :userid => newuserid)
  end

  def self.getClusters
    @clusters = Cluster.all
    return @clusters
  end

  def index
    @clusters = Cluster.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @clusters }
    end
  end

  # GET /clusters/1
  # GET /clusters/1.json
  def show
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @cluster }
    end
  end

  # GET /clusters/new
  # GET /clusters/new.json
  def new
    @cluster = Cluster.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @cluster }
    end
  end

  # GET /clusters/1/edit
  def edit
    @cluster = Cluster.find(params[:id])
  end

  # POST /clusters
  # POST /clusters.json
  def create
    @cluster = Cluster.new(params[:cluster])

    respond_to do |format|
      if @cluster.save
        format.html { redirect_to @cluster, :notice => 'Cluster was successfully created.' }
        format.json { render :json => @cluster, :status => :created, :location => @cluster }
      else
        format.html { render :action => "new" }
        format.json { render :json => @cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clusters/1
  # PUT /clusters/1.json
  def update
    @cluster = Cluster.find(params[:id])

    respond_to do |format|
      if @cluster.update_attributes(params[:cluster])
        format.html { redirect_to @cluster, :notice => 'Cluster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @cluster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clusters/1
  # DELETE /clusters/1.json
  def destroy
    @cluster = Cluster.find(params[:id])
    @cluster.destroy

    respond_to do |format|
      format.html { redirect_to clusters_url }
      format.json { head :no_content }
    end
  end
end
