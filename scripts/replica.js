// Bổ sung: xác nhận cụm Atlas là replica set 3 nút từ phía ứng dụng
require('dotenv').config();
const mongoose = require('mongoose');

(async () => {
  await mongoose.connect(process.env.MONGODB_URI);
  const h = await mongoose.connection.db.admin().command({ hello: 1 });
  console.log({ replicaSet: h.setName, primary: h.primary, hosts: h.hosts, connectedTo: h.me });
  await mongoose.disconnect();
})();
