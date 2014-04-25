class EditPackagesController < ApplicationController

  #This method displays the form and the layout
  # no parameters because it just displays the form
  # Returns the form
  # Author: Youssef A. Saleh.

  def  edit_package
  end

  #This methods gets the user his list of trips to edit what he wants
  # current_user_id - int, current_user_packages - list of the user's package
  # Returns: list of the user's Packages
  # Author: Youssef A. Saleh
  
  def  index
    @current_user_id = cookies[ :user_id ]
    @current_user_packages = Packages.find(:all, :conditions => {:senders_id => @current_user_id})
  end


  # This method send notification to the carrier when the sender edits his trip
  # requests - get the request of the current user, carriers_id - array of the carriers ids that sent requests to/from the user(sender), carrier_id - each carrier_id in the matching list in requests, notification - the notification that will be sent to the carriers if any, user - gets the username of the carrier that will be notified
  # Returns: sends notification to the matching carriers if any
  # Author: Youssef A. Saleh

  def  notification (user_id)
    requests=Requests.find(:all, :conditions => {:senders_id => user_id})
    if(requests != nil)
      carriers_id = Array.new
      requests.each do |t|
      carrier_id = t.carriers_id;
      carriers_id.push carrier_id;
      end
      
      carriers_id.each do |s|
        notification =  Notifications.new;
        notification.users_id = s;
        user = Users.find_by_id(user_id).username
    
        requests.each do |t|
          if (t.carriers_id == s)
            notification.description = user +" "+ "edited his/her package, please try to check it again!";
            notification.save;
          end
        end
      end

      return;          
    end
  end


  # This method edits the package of the current user
  # current_user_id - the current logged in user - int, current_package - the package being edited - package, current_user_request - the carrying request of the current user - request, is_accepted - the status of the carrying request whether accepted or not - boolean, carrier_id - the carrier id that matches requests with the current user - int, destination - package's destination - String, description = package's description - String, origin - package's origin - String, package_value - package's value - int, expiry_date - package's expiry date - date, carrying_price - package's price - int, receiver_address - package's receiver address - String, receiver_email - package's receiver_email - String, receiver_mob_number - package's receiver mobile number, weight - package's weight - int, data_validated - boolean, package - the edited package - package
  # Returns: edit the package details and send notification to the carrier if any
  # Author: Youssef A. Saleh

  def  update

    @current_user_id = cookies[ :user_id ]
    @current_package = Packages.find(params[ :id ])
    @current_user_request = Requests.find(:all, :conditions => {:senders_id => @current_user_id, :packages_id => @current_package.id})
    @current_user_request.each do |t|
      @is_accepted = t.accept
      @carrier_id = t.carriers_id
    end
    @destination = params[ :required_destination]
    @description = params[ :required_description ]
    @origin = params[ :required_origin ]
    @package_value = params[ :required_num_value ]
    @expiry_date = params[ :required_expirydate ]
    @carrying_price = params[ :required_num_price ]
    @receiver_address = params[ :required_address ]
    @receiver_mob_number = params[ :required_num_mobile ]
    @receiver_email = params[ :required_email ]
    @weight = params[ :required_num_weight ]
    @data_validated = true

    if (@destination == nil or !(@destination =~ /\S/) or @expiry_date == nil or !(@expiry_date =~ /\S/) or @description == nil or !(@description =~ /\S/) or @origin == nil or !(@origin =~ /\S/) or @package_value == nil or !(@package_value =~ /\S/) or @carrying_price == nil or !(@carrying_price =~ /\S/) or @receiver_address == nil or !(@receiver_address =~ /\S/) or @receiver_email == nil or !(@receiver_email =~ /\S/) or @receiver_mob_number == nil or !(@receiver_mob_number =~ /\S/) or @weight == nil or !(@weight =~ /\S/) or !(is_numeric(@package_value)) or !(is_numeric(@carrying_price)) or !(@expiry_date =~ /\A(?:0?[1-9]|1[0-2])\/(?:0?[1-9]|[1-2]\d|3[01])\/\d{4}\Z/) or !(is_numeric(@weight)) or !(is_numeric(@receiver_mob_number)))
      @data_validated = false
    end 

    if(@current_user_id == @current_package.senders_id && @is_accepted != true && @data_validated == true)
      @package_id = @current_package.id
      @current_package.id = @package_id
      @current_package.destination = params[ :required_destination ]
      @current_package.description = params[ :required_description ]
      @current_package.origin = params[ :required_origin ]
      @current_package.packageValue = params[ :required_num_value ]
      @current_package.expiryDate = params[ :required_expirydate ]
      @current_package.carryingPrice = params[ :required_num_price ]
      @current_package.receiverAddress = params[ :required_address ]
      @current_package.receiverMobNumber = params[ :required_num_mobile ]
      @current_package.receiverEmail = params[ :required_email ]
      @current_package.weight = params[ :required_num_weight ]
      @current_package.senders_id = @current_user_id
      @current_package.save
      notification(@current_user_id)
    end
    redirect_to :action =>'index'     
  end


  # This method gets whether an object is an integer or not
  # o - the input sent to the method when called - object
  # Returns - boolean
  # Author: Youssef A. Saleh

  def  is_numeric(o)
    true if Integer(o) rescue false
  end

end
