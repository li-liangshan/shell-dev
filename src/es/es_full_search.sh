#!/usr/bin/env bash

### 超越全文检索
#  使用聚合来聚合索引数据，并从中计算有用的信息;
#  采用切面来计算不同的统计数据;
#  使用Elasticsearch建议器实现拼写检查和自动完成功能;  使用预搜索来匹配文档;
#  索引二进制文件;
#  索引和搜索地理数据;
#  高效获取大数据集;
#  自动加载并在查询中使用词条。

## 1 聚合
# 1.1 一般查询结构: 为了使用聚合(aggregation)，需要在查询中增加一个额外节点。一般来说，使用聚合的查询看上去像下面的代码片段:
{
  "query": { ... },
  "aggs" : { ... }
}
# aggs属性(你可以使用aggregations属性，aggs只是个缩写)，可以定义任意数量的聚合。然而要记住一件事，键值定义了聚合的名称(需要它来区分服务
# 器响应中的特定聚合)。我们使用library索引，创建第一个使用聚合的查询。发送如下查询命令:
curl 'localhost:9200/_search? Search_type=count & pretty' -d '{
  "aggs": {
    "years": {
      "stats": {
        "field": "year"
      }
    },
    "words": {
      "terms": {
        "field": "copies"
      }
    }
  }
}'
# 此查询定义了两个聚合。名为years的聚合显示year字段的统计信息，words聚合包含给定 字段中所使用词条的信息。
# 查询中定义的第一个聚合(years)返回了给定字段的一 般统计，它是从所有匹配查询的文档中搜集而来的。
# 第二个聚合(words)有点不同，它创建了名为buckets的集合，基于返回文档计算而来，每个聚合值都出现在集合里。
# 可以看到，有多种聚合类型，每种都返回不同的结果。

# 1.2 可用的聚合
# 有两组聚合:度量聚合(metric aggregation)和桶聚合(bucketing aggregation)。
# 1. 度量聚合:度量聚合接收一个输入文档集并生成至少一个统计值。
# min、max、sum和avg聚合的使用很相似。它们对于给定字段分别返回最小值、最大值、总和和平均值。任何数值型字段都可以作为这些值的源。
{
  "aggs": { "min_year": { "min": { "field": "year" } } }
}
# 使用脚本: 输入值也可以由脚本生成。如果想找到year字段所有值的最小值，且要从这些值中减去1000，我们将发送如下聚合:
{
  "aggs": {"min_year": {"min": { "script": "doc['year'].value - 1000"} }
}

# 2. 桶聚合
# terms聚合为字段中每个词条返回一个桶。这允许你生成字段每个值的统计。
