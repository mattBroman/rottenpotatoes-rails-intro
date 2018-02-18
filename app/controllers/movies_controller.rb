class MoviesController < ApplicationController
  

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    unless (params[:ratings] == nil)
      session[:ratings] = params[:ratings]
    end 
    unless (params[:sort] == nil)
      session[:sort] = params[:sort]
    end
    if (session[:ratings] == nil)
      session[:ratings] = Hash[@all_ratings.map{ |x| [x, 1]}]
    end
	@movies = Movie.where(rating: session[:ratings].keys).order(session[:sort])
	@sortby = session[:sort]
	@checked = session[:ratings].keys
	  
  end
  
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    flash.keep
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    flash.keep
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    flash.keep
    redirect_to movies_path
  end

end
