# frozen_string_literal: true
require 'digest'

class Mailchimp::ListUpdater
  # MailchimpFailed = Class.new(ServiceActionError)

  def initialize(user, subscribe = true)
    @list_id = ENV['MAILCHIMP_AUDIENCE_ID']
    @mailchimp = Gibbon::Request
    @user = user
    @status = subscribe ? 'subscribed' : 'unsubscribed'
  end

  def call
    begin
      @mailchimp.lists(@list_id).members(lower_case_md5_hashed_email_address).retrieve
    rescue => exception
      @mailchimp.lists(@list_id).members.create(
          body: user_fields
      )
    end
  end

  def merge_fields
    {
        FNAME: @user.name,
        EMAIL: @user.email
    }
  end

  def user_fields
    {
        email_address: @user.email,
        status: @status,
        merge_fields: merge_fields
    }
  end

  def delete
    begin
      @mailchimp.lists(@list_id).members(lower_case_md5_hashed_email_address).retrieve
      @mailchimp.lists(@list_id).members(lower_case_md5_hashed_email_address).delete
    rescue => exception
      # go to next
    end
  end

  private
    def lower_case_md5_hashed_email_address
      Digest::MD5.hexdigest(@user.email.downcase)
    end

end

