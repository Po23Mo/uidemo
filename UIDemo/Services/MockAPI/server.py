#!/usr/bin/env python3
"""
极简 App Store 精选 - 模拟 API 服务器
提供 3 个静态 JSON 接口用于测试
"""

import json
import os
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

class MockAPIHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        """处理 GET 请求"""
        parsed_url = urlparse(self.path)
        path = parsed_url.path
        
        if path == '/app.json':
            self.serve_app_json()
        elif path == '/search':
            self.serve_search(parsed_url.query)
        else:
            self.send_error(404, "Not Found")
    
    def do_POST(self):
        """处理 POST 请求"""
        parsed_url = urlparse(self.path)
        path = parsed_url.path
        
        if path == '/collect':
            self.serve_collect()
        else:
            self.send_error(404, "Not Found")
    
    def serve_app_json(self):
        """提供 app.json 数据"""
        app_data = {
            "id": 1,
            "name": "极简天气",
            "version": "1.0.0",
            "description": "一款极简风格的天气应用，提供准确的天气预报和实时天气信息。界面简洁美观，功能实用，支持多城市天气查询，实时更新天气数据。",
            "iconURL": "https://via.placeholder.com/290x290/007AFF/FFFFFF?text=Weather",
            "screens": [
                "https://via.placeholder.com/290x290/FF9500/FFFFFF?text=Screen1",
                "https://via.placeholder.com/290x290/FF2D92/FFFFFF?text=Screen2",
                "https://via.placeholder.com/290x290/5856D6/FFFFFF?text=Screen3"
            ],
            "website": "https://example.com",
            "rating": 4.5,
            "reviews": [
                {
                    "author": "用户1",
                    "rating": 5,
                    "comment": "非常好用的天气应用，界面简洁美观",
                    "date": "2024-01-01"
                },
                {
                    "author": "用户2",
                    "rating": 4,
                    "comment": "界面简洁，功能齐全，推荐使用",
                    "date": "2024-01-02"
                },
                {
                    "author": "用户3",
                    "rating": 5,
                    "comment": "天气预报很准确，界面设计很棒",
                    "date": "2024-01-03"
                }
            ]
        }
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(app_data, ensure_ascii=False).encode('utf-8'))
    
    def serve_search(self, query_string):
        """提供搜索接口（返回空数组）"""
        query_params = parse_qs(query_string)
        search_query = query_params.get('q', [''])[0]
        
        # 这里可以根据搜索关键词返回不同的结果
        # 目前简单返回空数组
        search_results = []
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(json.dumps(search_results, ensure_ascii=False).encode('utf-8'))
    
    def serve_collect(self):
        """处理收藏请求"""
        # 读取请求体
        content_length = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_length)
        
        try:
            data = json.loads(post_data.decode('utf-8'))
            app_id = data.get('id')
            
            # 模拟收藏成功
            response = {"success": True, "message": f"应用 {app_id} 收藏成功"}
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response, ensure_ascii=False).encode('utf-8'))
            
        except json.JSONDecodeError:
            self.send_error(400, "Invalid JSON")
    
    def log_message(self, format, *args):
        """自定义日志格式"""
        print(f"[{self.address_string()}] {format % args}")

def run_server(port=8000):
    """启动服务器"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, MockAPIHandler)
    print(f"🚀 极简 App Store 模拟 API 服务器启动成功!")
    print(f"📍 服务地址: http://localhost:{port}")
    print(f"📋 可用接口:")
    print(f"   GET  /app.json     - 获取应用详情")
    print(f"   GET  /search?q=关键词 - 搜索应用")
    print(f"   POST /collect      - 收藏应用")
    print(f"⏹️  按 Ctrl+C 停止服务器")
    print("-" * 50)
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n🛑 服务器已停止")
        httpd.server_close()

if __name__ == '__main__':
    run_server() 