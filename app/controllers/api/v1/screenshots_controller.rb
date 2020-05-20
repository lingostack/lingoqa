# frozen_string_literal: true

module Api
  module V1
    # Controller methods to call a service of AWS S3
    class ScreenshotsController < ApplicationController
      before_action :product_version, :locale

      def index
        @screenshots = Screenshot.where(product_version_id: @version, locale_id: @locale)
        render json: @screenshots, include: :images
      end

      def new
        @screenshot = Screenshot.new
      end

      def create
        @screenshot = Screenshot.new(screenshot_params)
        @screenshot.save!
        rescue ActiveRecord::RecordInvalid => invalid
          render json: { errors: invalid.record.errors }
      end

      private
      def screenshot_params
        params.require(:screenshot).permit(:name, :locale_id, :product_version_id, images: [])
      end

      def product_version
        @version = ProductVersion.find(params[:product_version_id])
      end

      def locale
        @locale = Locale.find(params[:locale_id])
      end
    end
  end
end
