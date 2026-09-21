import '../entities/community.dart';

abstract class CommunitiesRepository {
  Future<List<Community>> getCommunities();
  Future<Community> getCommunityDetails(int id);
}
