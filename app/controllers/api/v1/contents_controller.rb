# frozen_string_literal: true

# TODO: Extract business logic to a services when controller grows
module Api
  module V1
    # Controller for managing Content resources
    #
    # Handles CRUD operations for Content objects
    class ContentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_content, only: %i[show update destroy]
      before_action :authorize_owner!, only: %i[update destroy]

      include ContentResponse

      # TODO: Replace custom with a pagination gem(custom pagination used here for simplicity)
      # GET /contents
      #
      # Fetches all Content records.
      # All authenticated users can view contents.
      #
      # @return [JSON] JSON:API formatted list of contents
      def index
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 20).to_i

        contents = Content.order(created_at: :desc)
                          .offset((page - 1) * per_page)
                          .limit(per_page)

        render_json_success(
          data: contents.map { |c| format_content_response(c) },
          message: 'Contents fetched successfully',
          meta: {
            pagination: {
              page: page,
              per_page: per_page,
              count: Content.count
            }
          }
        )
      end

      # GET /contents/:id
      #
      # Fetch a single Content by ID.
      # Any authenticated user can view the content.
      #
      # @return [JSON] JSON:API formatted single content
      def show
        render_json_success(data: format_content_response(@content), message: 'Content fetched successfully')
      end

      # POST /contents
      #
      # Creates a new Content associated with the current_user.
      #
      # @param [Hash] content_params permitted content attributes (:title, :body)
      # @return [JSON] JSON:API formatted created content or errors
      def create
        content = current_user.contents.build(content_params)

        if content.save
          render_json_success(
            data: format_content_response(content),
            message: 'Content created successfully',
            status: :created
          )
        else
          render_json_error(message: 'Content creation failed',
                            status: :unprocessable_content,
                            errors: content.errors.full_messages)
        end
      end

      # PATCH/PUT /contents/:id
      #
      # Updates an existing Content. Only the owner can update.
      #
      # @param [Hash] content_params permitted content attributes (:title, :body)
      # @return [JSON] JSON:API formatted updated content or errors
      def update
        if @content.update(content_params)
          render_json_success(
            data: format_content_response(@content),
            message: 'Content updated successfully'
          )
        else
          render_json_error(message: 'Content update failed',
                            status: :unprocessable_content,
                            errors: @content.errors.full_messages)
        end
      end

      # DELETE /contents/:id
      #
      # Deletes a Content. Only the owner can delete.
      #
      # @return [JSON] JSON:API formatted updated message or errors
      def destroy
        @content.destroy
        render_json_success(
          message: 'Content deleted successfully'
        )
      end

      private

      # Set the @content instance variable
      #
      # If the content is not found, responds with a JSON error with not_found statys
      def set_content
        @content = Content.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_json_error(status: :not_found, errors: ['Content not found'])
      end

      # Ensure current_user is the owner of the content
      #
      # @return [JSON] Forbidden error if current_user is not owner
      def authorize_owner!
        return if @content.user_id == current_user.id

        render_json_error(status: :forbidden, errors: ['You are not authorized to perform this action'])
      end

      # Strong parameters for Content
      #
      # @return [ActionController::Parameters] permitted params for content
      def content_params
        params.require(:content).permit(:title, :body, :page, :per_page)
      end
    end
  end
end
