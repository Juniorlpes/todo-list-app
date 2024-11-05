enum RestStatusCode {
  unknow('UNKNOW', 0),
  connectionError('CONNECTION_ERROR', 10),

  //1xx Informativo
  continues('CONTINUE', 100),
  switchingProtocol('SWITCHING_PROTOCOL', 101),
  processing('PROCESSING', 102),

  //2xx Sucesso
  ok('OK', 200),
  created('CREATED', 201),
  accepted('ACCEPTED', 202),
  nonAuthoritativeInformation('NON_AUTHORITATIVE_INFORMATION', 203),
  noContent('NO_CONTENT', 204),
  resetContent('RESET_CONTENT', 205),
  partialContent('PARTIAL_CONTENt', 206),
  multiStatus('MULTI_STATUS', 207),
  alreadyReported('ALREADY_REPORTED', 208),
  imUsed('IM_USED', 226),

  //3xx Redirecionamento
  multipleChoices('MULTIPLE_CHOICES', 300),
  movedPermanently('MOVED_PERMANENTLY', 301),
  found('FOUND', 302),
  seeOther('SEE_OTHER', 303),
  notModified('NOT_MODIFIED', 304),
  useProxy('USE_PROXY', 305),
  temporaryRedirect('TEMPORARY_REDIRECT', 307),
  permanentRedirect('PERMANENT_REDIRECT', 308),

  //4xx Erro no Cliente
  badRequest('BAD_REQUEST', 400),
  unauthorized('UNAUTHORIZED', 401),
  paymentRequired('PAYMENT REQUIRED', 402),
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
  expectationFailed('EXPECTATION FAILED', 417),
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

  //5xx Erro no Servidor
  internalServerError('INTERNAL_SERVER_ERROR', 500),
  notImplemented('NOT_IMPLEMENTED', 501),
  badGateway('BAD_GATEWAY', 502),
  serviceUnavailable('SERVICE_UNAVAILABLE', 503),
  gatewayTimeout('GATEWAY_TIMEOUT', 504),
  httpVersionNotSupported('HTTP_VERSION_NOT_SUPPORTED', 505),
  variantAlsoNegociates('VARIANT_ALSO_NEGOCIATES', 506),
  insufficientStorage('INSUFFICIENT_STORAGE', 507),
  loopDetected('LOOP_DETECTED', 508),
  notExtended('NOT_EXTENDED', 510),
  networkAuthenticationRequired('NETWORK_AUTHENTICATION_REQUIRED', 511),
  networkConnectionTimeoutError('NETWORK_CONNECTION_TIMEOUT_ERROR', 599);

  final String name;
  final int value;
  const RestStatusCode(this.name, this.value);

  @override
  String toString() => name;

  factory RestStatusCode.fromInt(int? code) {
    switch (code) {
      case 10:
        return RestStatusCode.connectionError;
      case 100:
        return RestStatusCode.continues;
      case 101:
        return RestStatusCode.switchingProtocol;
      case 102:
        return RestStatusCode.processing;
      case 200:
        return RestStatusCode.ok;
      case 201:
        return RestStatusCode.created;
      case 202:
        return RestStatusCode.accepted;
      case 203:
        return RestStatusCode.nonAuthoritativeInformation;
      case 204:
        return RestStatusCode.noContent;
      case 205:
        return RestStatusCode.resetContent;
      case 206:
        return RestStatusCode.partialContent;
      case 207:
        return RestStatusCode.multiStatus;
      case 208:
        return RestStatusCode.alreadyReported;
      case 226:
        return RestStatusCode.imUsed;
      case 300:
        return RestStatusCode.multipleChoices;
      case 301:
        return RestStatusCode.movedPermanently;
      case 302:
        return RestStatusCode.found;
      case 303:
        return RestStatusCode.seeOther;
      case 304:
        return RestStatusCode.notModified;
      case 305:
        return RestStatusCode.useProxy;
      case 307:
        return RestStatusCode.temporaryRedirect;
      case 308:
        return RestStatusCode.permanentRedirect;
      case 400:
        return RestStatusCode.badRequest;
      case 401:
        return RestStatusCode.unauthorized;
      case 402:
        return RestStatusCode.paymentRequired;
      case 403:
        return RestStatusCode.forbidden;
      case 404:
        return RestStatusCode.notFound;
      case 405:
        return RestStatusCode.methodNotAllowed;
      case 406:
        return RestStatusCode.notAcceptable;
      case 407:
        return RestStatusCode.proxyAuthenticationRequired;
      case 408:
        return RestStatusCode.requestTimeout;
      case 409:
        return RestStatusCode.conflict;
      case 410:
        return RestStatusCode.gone;
      case 411:
        return RestStatusCode.lengthRequired;
      case 412:
        return RestStatusCode.preconditionFailed;
      case 413:
        return RestStatusCode.payloadTooLarge;
      case 414:
        return RestStatusCode.requestURITooLong;
      case 415:
        return RestStatusCode.unsupportedMediaType;
      case 416:
        return RestStatusCode.requestedRangeNotSatisfiable;
      case 417:
        return RestStatusCode.expectationFailed;
      case 418:
        return RestStatusCode.iamATeapot;
      case 421:
        return RestStatusCode.misdirectedRequest;
      case 422:
        return RestStatusCode.unprocessableEntity;
      case 423:
        return RestStatusCode.locked;
      case 424:
        return RestStatusCode.failedDependency;
      case 426:
        return RestStatusCode.upgradeRequired;
      case 428:
        return RestStatusCode.preconditionRequired;
      case 429:
        return RestStatusCode.tooManyRequests;
      case 431:
        return RestStatusCode.requestHeaderFieldsTooLarge;
      case 444:
        return RestStatusCode.connectionClosedWithoutResponse;
      case 451:
        return RestStatusCode.unavailableForLegalReasons;
      case 499:
        return RestStatusCode.clientClosedRequest;
      case 500:
        return RestStatusCode.internalServerError;
      case 501:
        return RestStatusCode.notImplemented;
      case 502:
        return RestStatusCode.badGateway;
      case 503:
        return RestStatusCode.serviceUnavailable;
      case 504:
        return RestStatusCode.gatewayTimeout;
      case 505:
        return RestStatusCode.httpVersionNotSupported;
      case 506:
        return RestStatusCode.variantAlsoNegociates;
      case 507:
        return RestStatusCode.insufficientStorage;
      case 508:
        return RestStatusCode.loopDetected;
      case 510:
        return RestStatusCode.notExtended;
      case 511:
        return RestStatusCode.networkAuthenticationRequired;
      case 599:
        return RestStatusCode.networkConnectionTimeoutError;
      default:
        return RestStatusCode.unknow;
    }
  }
}
