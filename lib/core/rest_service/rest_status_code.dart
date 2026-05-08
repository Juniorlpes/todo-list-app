enum RestStatusCode {
  unknow('UNKNOW', 0),
  connectionError('CONNECTION_ERROR', 10),

  //1xx Informational
  continues('CONTINUE', 100),
  switchingProtocol('SWITCHING_PROTOCOL', 101),
  processing('PROCESSING', 102),

  //2xx Success
  ok('OK', 200),
  created('CREATED', 201),
  accepted('ACCEPTED', 202),
  nonAuthoritativeInformation('NON_AUTHORITATIVE_INFORMATION', 203),
  noContent('NO_CONTENT', 204),
  resetContent('RESET_CONTENT', 205),
  partialContent('PARTIAL_CONTENT', 206),
  multiStatus('MULTI_STATUS', 207),
  alreadyReported('ALREADY_REPORTED', 208),
  imUsed('IM_USED', 226),

  //3xx Redirection
  multipleChoices('MULTIPLE_CHOICES', 300),
  movedPermanently('MOVED_PERMANENTLY', 301),
  found('FOUND', 302),
  seeOther('SEE_OTHER', 303),
  notModified('NOT_MODIFIED', 304),
  useProxy('USE_PROXY', 305),
  temporaryRedirect('TEMPORARY_REDIRECT', 307),
  permanentRedirect('PERMANENT_REDIRECT', 308),

  //4xx Client Error
  badRequest('BAD_REQUEST', 400),
  unauthorized('UNAUTHORIZED', 401),
  paymentRequired('PAYMENT_REQUIRED', 402),
  forbidden('FORBIDDEN', 403),
  notFound('NOT_FOUND', 404),
  methodNotAllowed('METHOD_NOT_ALLOWED', 405),
  notAcceptable('NOT_ACCEPTABLE', 406),
  proxyAuthenticationRequired('PROXY_AUTHENTICATION_REQUIRED', 407),
  requestTimeout('REQUEST_TIMEOUT', 408),
  conflict('CONFLICT', 409),
  gone('GONE', 410),
  lengthRequired('LENGTH_REQUIRED', 411),
  preconditionFailed('PRECONDITION_FAILED', 412),
  payloadTooLarge('PAYLOAD_TOO_LARGE', 413),
  requestURITooLong('REQUEST_URI_TOO_LONG', 414),
  unsupportedMediaType('UNSUPPORTED_MEDIA_TYPE', 415),
  requestedRangeNotSatisfiable('REQUESTED_RANGE_NOT_SATISFIABLE', 416),
  expectationFailed('EXPECTATION_FAILED', 417),
  iamATeapot('I_AM_A_TEAPOT', 418),
  misdirectedRequest('MISDIRECTED_REQUEST', 421),
  unprocessableEntity('UNPROCESSABLE_ENTITY', 422),
  locked('LOCKED', 423),
  failedDependency('FAILED_DEPENDENCY', 424),
  upgradeRequired('UPGRADE_REQUIRED', 426),
  preconditionRequired('PRECONDITION_REQUIRED', 428),
  tooManyRequests('TOO_MANY_REQUESTS', 429),
  requestHeaderFieldsTooLarge('REQUEST_HEADER_FIELDS_TOO_LARGE', 431),
  connectionClosedWithoutResponse('CONNECTION_CLOSED_WITHOUT_RESPONSE', 444),
  unavailableForLegalReasons('UNAVAILABLE_FOR_LEGAL_REASONS', 451),
  clientClosedRequest('CLIENT_CLOSED_REQUEST', 499),

  //5xx Server Error
  internalServerError('INTERNAL_SERVER_ERROR', 500),
  notImplemented('NOT_IMPLEMENTED', 501),
  badGateway('BAD_GATEWAY', 502),
  serviceUnavailable('SERVICE_UNAVAILABLE', 503),
  gatewayTimeout('GATEWAY_TIMEOUT', 504),
  httpVersionNotSupported('HTTP_VERSION_NOT_SUPPORTED', 505),
  variantAlsoNegotiates('VARIANT_ALSO_NEGOTIATES', 506),
  insufficientStorage('INSUFFICIENT_STORAGE', 507),
  loopDetected('LOOP_DETECTED', 508),
  notExtended('NOT_EXTENDED', 510),
  networkAuthenticationRequired('NETWORK_AUTHENTICATION_REQUIRED', 511),
  networkConnectionTimeoutError('NETWORK_CONNECTION_TIMEOUT_ERROR', 599);

  final String label;
  final int code;
  const RestStatusCode(this.label, this.code);

  @override
  String toString() => label;

  factory RestStatusCode.fromInt(int? code) {
    if (code == null) return RestStatusCode.unknow;
    return RestStatusCode.values.firstWhere(
      (e) => e.code == code,
      orElse: () => RestStatusCode.unknow,
    );
  }
}
