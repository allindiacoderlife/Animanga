import 'package:animanga/core/constants/api_endpoints.dart';
import 'package:animanga/core/network/api_client.dart';
import 'package:animanga/features/manga/domain/models/manga_model.dart';
import 'package:animanga/features/manga/domain/models/manga_detail_model.dart';

class MangaRepository {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<MangaModel>> getTopManga() async {
    final url = '${ApiEndpoints.baseUrl}top/manga';
    final response = await _apiClient.getData(url);

    if (response != null && response['data'] != null) {
      final List data = response['data'];
      return data.map((json) => MangaModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<List<MangaModel>> searchManga({
    String? query,
    String? type,
    String? status,
    double? score,
    bool? sfw,
    String? orderBy,
    String? sort,
    int? page,
    int? limit,
  }) async {
    final url = '${ApiEndpoints.baseUrl}manga';

    final Map<String, dynamic> queryParams = {
      if (query != null) 'q': query,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (sfw != null) 'sfw': sfw,
      if (orderBy != null) 'order_by': orderBy,
      if (sort != null) 'sort': sort,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };

    final response = await _apiClient.getData(
      url,
      queryParameters: queryParams,
    );

    if (response != null && response['data'] != null) {
      final List data = response['data'];
      return data.map((json) => MangaModel.fromJson(json)).toList();
    }

    return [];
  }

  Future<MangaDetailModel?> getMangaFull(int id) async {
    final url = '${ApiEndpoints.baseUrl}manga/$id/full';
    final response = await _apiClient.getData(url);

    if (response != null && response['data'] != null) {
      return MangaDetailModel.fromJson(response['data']);
    }

    return null;
  }
}
