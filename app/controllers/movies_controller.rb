class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    @ratings_to_show = [] #Creating an empty array
    @all_ratings = Movie.all_ratings

    byebug
    if params.key?(:home) || params.key?(:ratings) 
      session[:sort] = params[:sort]
      session[:ratings] = params[:ratings]
    else
      params[:sort] = session[:sort]
      if params[:commit]!="Refresh" 
        params[:ratings] = session[:ratings]
      
      else
        session[:ratings] = params[:ratings]
      end
    end
    
    
    if params.key?(:ratings) && params[:ratings].nil? == false
      @ratings_to_show = params[:ratings].keys
    end
    
    if @ratings_to_show.nil? || @ratings_to_show.empty?
      @movies = Movie.all
    else 
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    
    if params.key?(:sort)
        @movies = @movies.order(params[:sort])
        
        if params[:sort] == "title"
          @title_sort = "hilite"
          @release_date_sort = ""
        elsif params[:sort] == "release_date"
          @title_sort = ""
          @release_date_sort = "hilite"
        end
          
      
    end
   
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
