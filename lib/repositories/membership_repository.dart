import 'package:court_reserve_app/models/membership.dart';
import 'package:court_reserve_app/networking/retrofit/clients/membership_client.dart';
import 'package:court_reserve_app/networking/retrofit/retrofit_controller.dart';
import 'package:court_reserve_app/repositories/authentication_repository.dart';

class MembershipRepository {
  final MembershipClient _membershipClient;
  final AuthenticationRepository _authenticationRepository;

  MembershipRepository()
      : _membershipClient = RetrofitController.membershipClient(),
        _authenticationRepository = AuthenticationRepository();

  Future<Membership> getMembership() async {
    int userId = await _authenticationRepository.getUserId();
    var response = await _membershipClient.getMembership(userId: userId);
    return Membership.fromJson(response);
  }

  Future<Membership> createMembership(Membership membership) async {
    int userId = await _authenticationRepository.getUserId();
    var response = await _membershipClient.createMembership(
      membership: membership.toJson()..addAll({"userId": userId}),
    );
    return Membership.fromJson(response);
  }

  Future<bool> updateMembership(Membership membership) async {
    int userId = await _authenticationRepository.getUserId();
    await _membershipClient.updateMembership(
      membership: membership.toJson()..addAll({"userId": userId}),
    );
    return true;
  }

  Future<bool> deleteMembership() async {
    int userId = await _authenticationRepository.getUserId();
    await _membershipClient.deleteMembership(userId: userId);
    return true;
  }
}
