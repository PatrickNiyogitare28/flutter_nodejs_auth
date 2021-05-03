const express = require("express");
const app = express();
const mongoose = require("mongoose");
// db
// mongodb://<dbuser>:<dbpassword>@ds049558.mlab.com:49558/auth
async function connectDB() {
  await mongoose.connect(
    "mongodb://localhost/flutter_auth",
    { useUnifiedTopology: true, useNewUrlParser: true }
  );

  console.log("db connected");
}
connectDB();

// this takes the post body
app.use(express.json({ extended: false }));

app.get("/", (req, res) => res.send("Hello World!"));
// signup route api
app.post("/signup", async (req, res) => {
  console.log("Hello.....................");
  const { email, password } = req.body;
  console.log(email);
  console.log(password);
  var schema = new mongoose.Schema({ email: "string", password: "string" });
  var User = mongoose.model("User", schema);

  let user = new User({
    email,
    password,
  });
  console.log(user);

  await user.save();
  res.json({ token: "1234567890" });
  // check db for email if email say the email is already taken
  //   return res.send("Signup api route");
});

app.listen(5000, () => console.log("Example app listening on port 5000!"));