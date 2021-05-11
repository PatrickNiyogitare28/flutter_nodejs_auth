const express = require("express");
const app = express();
const mongoose = require("mongoose");
const argon = require('argon2');
const jwt = require('jsonwebtoken');
const _  = require('lodash');
const morgan = require('morgan')
require('dotenv').config();
/*
 @Role : defining data to be picked by lodash
*/
const pickableData = ['_id','name', 'email'];

/*
  @Role : connecting the app to mongodb server using mongoose 
*/
async function connectDB() {
  await mongoose.connect(
    "mongodb://localhost/flutter_node_auth",
    { useUnifiedTopology: true, useNewUrlParser: true }
  );
}
connectDB();

/*
 @Role logging triggered endpoints
*/
app.use(morgan('tiny'));

/*
 @Role this takes the post body
*/
 app.use(express.json({ extended: false }));

/*
 @Role : db initialization and defining User collection definition
*/
var schema = new mongoose.Schema({ 
  name: {
    type: String
  },
  email: {
    type: String,
    unique: true
  }, 
  password: {
    type: String
  } });
var User = mongoose.model("User", schema);

/*
 @Role: base sever route api
*/
app.get("/", (req, res) => res.send("Welcome to nodejs server"));

/*
 @Role: signup route api
*/
app.post("/signup", async (req, res) => {
  let { name,email, password}  = req.body;
  let emailExist = await findUserByEmail(email);
  if(emailExist)
    return res.status(406).json({message:'Email aready exists'});

  password = await _hashPass(password);
  let user = new User({
    name,
    email,
    password,
  });
  
  await user.save();
  const token = await signToken(_.pick(user,pickableData));
  res.status(201).json({message:'user registered',token});
});

/*
 @Role: login route api
*/
app.post('/login',async(req,res) => {
   const {email,password} = req.body;
   let user = await findUserByEmail(email);
   if(!user)
    return res.status(401).json({message: 'Invalid email or password'});
   
   let passwordVerify = await _verfyPass(user.password, password);
   if(!passwordVerify)
     return res.status(401).json({message: 'Invalid email or password'});
   let token = await signToken(_.pick(user,pickableData));
   return res.status(200).json({message: 'logged in successfull', token});
    
})

/*
 @Role : route api to get user data
 @Header : authorization
 @Key : bearer
*/
app.get('/profile', async(req,res) => {
   const token = await req.headers.authorization.split(' ')[1];
   let userPayloads = await decodeToken(token);
   if(!userPayloads)
    return res.status(400).json({message: 'Invalid token'});
   return res.status(200).json(userPayloads);
});

/*
 @Role : find user in db
 @Param : user email
*/
const findUserByEmail = async(email) => {
  let user = await User.findOne({email});
  if(!user)
    return false;
   return user; 
}

/*
 @Role : getting jwt key from environment variables
*/
const _jwt_key =  process.env.JWT_KEY;

/*
 @Role : sign token
 @Param : user data object
*/
const signToken = (payloads) => {
    const token  = jwt.sign(JSON.parse(JSON.stringify(payloads)), _jwt_key, { expiresIn: 60 * 60 * 5 });
    return token;
}

/*
 @Role : decode token and return user data
 @Param : token
*/
const decodeToken = (token) => {
    try{
      let decodes = jwt.decode(token, _jwt_key);
      return decodes;
      
    }
    catch(e) {
      return false;
    }
}

/*
 @Role : hashing the password
 @Param : unhashed/plain password
*/
const _hashPass = async(password) => {
   return argon.hash(password);
}

/*
 @Role : Verifying the password
 @Param : hashed password - plain password/unhashed
*/
const _verfyPass = async(hashed, unhashed) => {
   return argon.verify(hashed, unhashed);
}

/*
 @Role : setting the app server
*/
const port = process.env.PORT || 5000
app.listen(port, () => console.log("Server 🏃‍♂️🏃‍♂️🏃‍♀️🏃 on port 5000!"));