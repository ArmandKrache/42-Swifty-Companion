import 'package:swifty_companion/src/domain/models/coalition/campus_coalitions_list_response.dart';
import 'package:swifty_companion/src/domain/models/coalition/user_coalitions_list_response.dart';
import 'package:swifty_companion/src/domain/models/event/event_list_response.dart';
import 'package:swifty_companion/src/domain/models/login_response.dart';
import 'package:swifty_companion/src/domain/models/student/student_details.dart';
import 'package:swifty_companion/src/domain/models/student/student_list_response.dart';
import 'package:swifty_companion/src/domain/models/token_info_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.intra.42.fr/", parser: Parser.MapSerializable)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST('oauth/token')
  Future<HttpResponse<LoginResponse>> getTokens(@Body() Map<String, dynamic> credentials);

  @GET('oauth/token/info')
  Future<HttpResponse<TokenInfoResponse>> getTokenInfo();

  @GET('v2/users?campus_id=1&filter%5Blogin%5D={login}')
  Future<HttpResponse<StudentListResponse>> getStudentByLogin(@Path() String login);

  @GET('v2/users/{id}')
  Future<HttpResponse<StudentDetails>> getStudentDetails(@Path() String id);

  @GET('v2/blocs?filter%5Bid%5D={id}')
  Future<HttpResponse<CampusCoalitionListResponse>> getCoalitions({@Path() required String id});

  @GET('v2/events?campus_id=1&filter[future]=true&sort=begin_at')
  Future<HttpResponse<EventListResponse>> getParisFutureEvents();

  @GET('v2/coalitions?user_id={id}')
  Future<HttpResponse<UserCoalitionListResponse>> getUserCoalitions({@Path() required String id});
}