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
    # list rating ratings from the class method of Movie
    @all_ratings = Movie.all_ratings
    @cur_ratings = Hash.new

    
    if params[:ratings]
      @movies = Movie.where({rating: params[:ratings].keys})
      session[:ratings] = params[:ratings]
      # session[:sort_by] = params[:sort_by]
      session[:ratings].keys.each do |rating|
        @cur_ratings[rating] = 1
      end
      
      
        
    elsif session[:ratings] and session[:sort_by]
      @movies = Movie.order(session[:sort_by]).where({rating: session[:ratings].keys})
      session[:ratings].keys.each do |rating|
        @cur_ratings[rating] = 1
      end  
      # redirect_to movies_path
      
    # if session has ratings stored  
    elsif session[:ratings] and session[:sort_by] == nil
      @movies = Movie.order(params[:sort_by]).where({rating: session[:ratings].keys})
      session[:ratings].keys.each do |rating|
        @cur_ratings[rating] = 1
      end
      
    else
      @movies = Movie.order(params[:sort_by])
      session[:sort_by] = params[:sort_by]
      @all_ratings.each do |rating|
        @cur_ratings[rating] = 1
      end
    end
     
    if params[:sort_by] == 'title'
      @title_header = 'hilite'
    elsif params[:sort_by] == 'release_date'
      @release_date_header = 'hilite'
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

end
