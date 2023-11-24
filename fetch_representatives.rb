# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

service = Google::Apis::CivicinfoV2::CivicInfoService.new
service.key = '' # 用你的 API 密钥替换此文本

address = '1611 San Pablo Ave, Berkeley, CA' # 用你想查询的地址替换此文本
result = service.representative_info_by_address(address: address)

# 处理并输出结果
puts result.inspect
