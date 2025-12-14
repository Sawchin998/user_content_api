# frozen_string_literal: true

# Module to format content response
module ContentResponse
  extend ActiveSupport::Concern

  #
  # Format a content object and token into a JSON:API-style response.
  #
  # @param [Content] content the content object
  # @return [Hash] formatted content response
  #
  def format_content_response(content)
    {
      id: content.id,
      type: 'content',
      attributes: {
        title: content.title,
        body: content.body,
        createdAt: content.created_at.iso8601,
        updatedAt: content.updated_at.iso8601
      }
    }
  end
end
