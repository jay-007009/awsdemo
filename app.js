const express=require('express')
const app=express()




app.get('/',(req,res)=>{
res.send("service is running")
})

app.listen(4001,()=>{
    console.log(`server is up `)

})

