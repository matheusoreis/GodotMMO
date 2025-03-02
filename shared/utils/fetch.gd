extends Node


func fetch(method: HTTPClient.Method, url: String, headers: Dictionary, body: String) -> Array:
	var request := HTTPRequest.new()
	add_child(request)

	var packed_headers := PackedStringArray()
	for key in headers:
		packed_headers.push_back('%s: %s' % [key, headers[key]])

	var err := request.request(url, packed_headers, method, body)
	if err != OK:
		remove_child(request)
		return [FAILED, 0, { "message": ["Erro ao enviar a requisição."]}]

	var results := (await request.request_completed) as Array
	remove_child(request)

	var status_code = results[1]

	if results[0] == OK:
		return [OK, status_code, (results[3] as PackedByteArray).get_string_from_utf8()]
	else:
		return [FAILED, status_code, { "message": ["Erro ao enviar a requisição."]}]


func fetch_json(method: HTTPClient.Method, url: String, body: Dictionary = {}, headers: Dictionary = {}) -> Array:
	if not headers.has('Content-Type'):
		headers['Content-Type'] = 'application/json'

	var result := await fetch(method, url, headers, JSON.stringify(body) if body.size() > 0 else '')
	if result[0] == FAILED:
		return result

	var status_code = result[1]

	return [OK, status_code, JSON.parse_string(result[2])]
