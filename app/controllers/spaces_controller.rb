require 'csv'

class SpacesController < ApplicationController
  layout 'embed', except: :index

  def index
    @space_names = current_user.admin_of_space_names
    if @space_names.size == 1
      redirect_to space_path(@space_names.first)
    end
  end

  def show
    @space = Space.find_by_name!(params[:id])
    check_permission @space do
      respond_to do |format|
        format.html do
          if params[:cobot_embed]
            session[:cobot_embed] = true
          elsif !session[:cobot_embed]
            client = CobotClient::ApiClient.new current_user.oauth_token
            links = CobotClient::NavigationLinkService.new(client, @space.subdomain).install_links [
              CobotClient::NavigationLink.new(section: 'admin/manage',
                label: 'Inventory', iframe_url: request.url)]
            redirect_to links.first.user_url
          end
        end
        format.csv do
          send_data space_csv(@space), filename: "inventory-#{Date.current}.csv"
        end
      end
    end
  end

  private

  def space_csv(space)
    CSV.generate(col_sep: '|') do |csv|
      csv << ['Resource', 'Category', 'Member']
      space.resources.sort{ |r1, r2| [r1.category.name, r1.name] <=> [r2.category.name, r2.name] }.each do |r|
        csv << [r.name, r.category.name, r.member_name]
      end
    end
  end
end
