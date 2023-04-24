


resource "aws_elasticache_cluster" "MyRedisCache" {
    cluster_id = "my-redis-cache"
    engine = "redis"
}