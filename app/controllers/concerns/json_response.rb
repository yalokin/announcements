module JsonResponse
  def json_response(object, status: :ok, view: action_name.to_sym)
    klass = controller_name.classify + 'Blueprint'
    blueprint = klass.constantize
    json = blueprint.render object, view: view
    render json: json, status: status
  end
end