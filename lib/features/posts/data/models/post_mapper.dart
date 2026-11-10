import '../../domain/entities/post.dart' as domain;
import 'post.dart' as dto;

extension PostModelMapper on dto.Post {
  domain.Post toEntity() => domain.Post(userId: userId, id: id, title: title, body: body);
}
