class SearchsController < ApplicationController
 	def search
 		@user_or_book = params[:option]
 		@how_search = params[:choice]

 		if @user_or_book == "user"
 			@users = User.search(params[:search], @user_or_book, @how_search)
 		else
 			@books = Book.search(params[:search], @user_or_book, @how_search)
 		end
  	end
end