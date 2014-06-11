class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def index
  #   @all_ratings = Movie.rate

  #   @checked_ratings = params[:ratings].keys if params[:ratings]

  #   if params[:ratings]
  #     @movies = Movie.where(rating: @checked_ratings)
  #   else
  #     @movies = Movies.order(params[:sort])
  #   end
  # end

  def index
    @all_ratings = Movie.list

    if session[:ratings].nil? 
      session[:ratings] = Hash.new
    @all_ratings.each do |rating|
      session[:ratings][rating] = "yes"
      end
    end

    session[:ratings] = params[:ratings] if params[:ratings]

    session[:sort] = params[:sort] if params[:sort]

    if params[:ratings] and params[:sort]
      @checked_ratings = session[:ratings].keys
      @movies = Movie.where(:rating => @checked_ratings).order(session[:sort])
    else
      parameters = Hash.new
      parameters[:ratings] = session[:ratings]
      parameters[:sort] = session[:sort]

      flash.keep
      redirect_to "/movies?#{parameters.to_query}"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
