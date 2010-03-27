module ContactableHelper
  def identification_label(identification)
    "#{identification.type ? identification.type.name : nil} - #{identification.code}"
  end

  def phone_label(phone)
    "#{phone.type ? phone.type.name : nil} - #{phone.number}"
  end

  def address_label(address)
    "#{address.type ? address.type.name : nil} - #{address.full_address}"
  end

  def email_label(email)
    "#{email.type ? email.type.name : nil} - #{email.address}"
  end

  def website_label(website)
    "#{website.type ? website.type.name : nil} - #{website.address}"
  end

  def instant_messenger_label(instant_messenger)
    "#{instant_messenger.type ? instant_messenger.type.name : nil} - #{instant_messenger.protocol ? instant_messenger.protocol.name : nil} - #{instant_messenger.nick}"
  end

    # Helpers for contact nested forms
  def add_new_record_link(record, name, form_builder)
    name = name.to_s
    plural_name = name.pluralize
    link_to_function "add a new #{name}", :class => 'add' do |page|
      new_record = record.send(plural_name).build
      form_builder.semantic_fields_for plural_name, new_record, :child_index => 'NEW_RECORD' do |p|
        html = "<fieldset class='inputs'><ol>#{render(:partial => plural_name + '/' + name, :locals => { :f => p, name.to_sym => new_record })}</ol></fieldset>"
        page << "$('##{plural_name}').append('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime()));"
      end
    end
  end

  # remove link
  def remove_link_unless_new_record(fields)
    out = ''
    out << fields.hidden_field(:_delete) unless fields.object.new_record?
    out << link_to_function("remove", "$(this).parent().parent().hide(); $(this).siblings('input[type=hidden]')[0].value = 1;", :class => 'remove')
    out
  end
end
