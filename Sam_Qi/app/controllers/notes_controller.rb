class NotesController < ApplicationController

    before_action :ensure_login, only: [:create,:update, :edit]
    def create
        @note = Note.new(note_params)
        @note.user_id = params[:user_id]
        if @note && @note.save
            redirect_to user_url(@note.user_id)
        else
            flash[:errors]=["Description can't be blank"]
            redirect_to user_url(params[:user_id])
        end
    end

    def edit
        @note = current_user.notes.find_by(id: params[:id])
        render :edit
    end

    def update
        @note = Note.find(params[:id])
        unless @note.user_id == current_user.id && @note.update(note_params)
            flash[:errors]= ["Something went wrong!"]         
        end
        redirect_to user_url(@note.user_id)
    end


    private

    def note_params
        params.require(:note).permit(:title, :description, :secret)
    end

end