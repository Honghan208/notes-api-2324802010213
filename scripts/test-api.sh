#!/usr/bin/env bash
# Thử 5 thao tác CRUD, tải tệp và các mã lỗi; mỗi lệnh in kèm mã HTTP
B=localhost:3000/notes
W='\n→ HTTP %{http_code}\n\n'
ID_OF() { node -pe "JSON.parse(require('fs').readFileSync(0,'utf8'))._id"; }

echo "## 1. POST /notes (tạo)"
curl -s -o /tmp/n.json -w "$W" -X POST $B -H "Content-Type: application/json" \
  -d '{"title":"Ôn chương 3","content":"HDFS vs GFS","tags":["cloud","nosql"]}'
cat /tmp/n.json; echo
ID=$(ID_OF < /tmp/n.json); echo "ID=$ID"; echo "$ID" > /tmp/note_id

echo; echo "## 2. GET /notes?tag=nosql"
curl -s -w "$W" "$B?tag=nosql"
echo "## 3. GET /notes/:id"
curl -s -w "$W" $B/$ID
echo "## 4. PUT /notes/:id (sửa)"
curl -s -w "$W" -X PUT $B/$ID -H "Content-Type: application/json" \
  -d '{"title":"Ôn chương 3 (đã sửa)","content":"HDFS vs GFS vs Atlas","tags":["cloud","nosql"]}'

echo "## 5. Tình huống lỗi"
echo "- GET id không tồn tại:";  curl -s -w "$W" $B/000000000000000000000000
echo "- GET id sai định dạng:";  curl -s -w "$W" $B/abc
echo "- POST thiếu title:";      curl -s -w "$W" -X POST $B -H "Content-Type: application/json" -d '{"content":"thiếu title"}'
echo "- POST attachment thiếu tệp:"; curl -s -w "$W" -X POST $B/$ID/attachment

echo "## 6. POST /notes/:id/attachment (tải tệp lên Supabase)"
echo "Tệp thử Bài 3 - Nguyễn Thị Hồng Hân" > /tmp/note.txt
curl -s -w "$W" -X POST $B/$ID/attachment -F "file=@/tmp/note.txt"

echo "## 7. DELETE: tạo ghi chú phụ rồi xóa"
ID2=$(curl -s -X POST $B -H "Content-Type: application/json" -d '{"title":"Ghi chú để xóa"}' | ID_OF)
echo "ID2=$ID2"
curl -s -w "$W" -X DELETE $B/$ID2
echo "- GET lại sau khi xóa:"; curl -s -w "$W" $B/$ID2
