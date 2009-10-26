# BetterMeans - Work 2.0
# Copyright (C) 2006  Shereef Bishay
#

module UsersHelper
  def users_status_options_for_select(selected)
    user_count_by_status = User.count(:group => 'status').to_hash
    options_for_select([[l(:label_all), ''], 
                        ["#{l(:status_active)} (#{user_count_by_status[1].to_i})", 1],
                        ["#{l(:status_registered)} (#{user_count_by_status[2].to_i})", 2],
                        ["#{l(:status_locked)} (#{user_count_by_status[3].to_i})", 3]], selected)
  end
  
  # Options for the new membership projects combo-box
  def options_for_membership_project_select(user, projects)
    options = content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---")
    options << project_tree_options_for_select(projects) do |p|
      {:disabled => (user.projects.include?(p))}
    end
    options
  end
  
  def change_status_link(user)
    url = {:controller => 'users', :action => 'edit', :id => user, :page => params[:page], :status => params[:status], :tab => nil}
    
    if user.locked?
      link_to l(:button_unlock), url.merge(:user => {:status => User::STATUS_ACTIVE}), :method => :post, :class => 'icon icon-unlock'
    elsif user.registered?
      link_to l(:button_activate), url.merge(:user => {:status => User::STATUS_ACTIVE}), :method => :post, :class => 'icon icon-unlock'
    elsif user != User.current
      link_to l(:button_lock), url.merge(:user => {:status => User::STATUS_LOCKED}), :method => :post, :class => 'icon icon-lock'
    end
  end
  
  def user_settings_tabs
    tabs = [{:name => 'general', :partial => 'users/general', :label => :label_general},
            {:name => 'groups', :partial => 'users/groups', :label => :label_group_plural},
            {:name => 'memberships', :partial => 'users/memberships', :label => :label_project_plural}
            ]
  end
end
