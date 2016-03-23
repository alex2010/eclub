schedule = require('node-schedule')


rule = new schedule.RecurrenceRule()

rule.minute = 40;

j = schedule.scheduleJob rule, ->
    log '40 for 1'
#j.cancel();

#周一到周日的20点执行
rule = new schedule.RecurrenceRule();
rule.dayOfWeek = [0, new schedule.Range(1, 6)];
rule.hour = 20;
rule.minute = 0;

j = schedule.scheduleJob rule, ->
    console.log("执行任务");


#    每秒执行
#
#    var rule = new schedule.RecurrenceRule();
#
#var times = [];
#
#for(var i=1; i<60; i++){
#
#times.push(i);
#
#}
#
#rule.second = times;
#
#var c=0;
#var j = schedule.scheduleJob(rule, function(){
#c++;
#console.log(c);
#});

#Thursday, Friday, Saturday, and Sunday at 5pm:
#var rule = new schedule.RecurrenceRule();
#rule.dayOfWeek = [0, new schedule.Range(4, 6)];
#rule.hour = 17;
#rule.minute = 0;
#
#var j = schedule.scheduleJob(rule, function(){
#console.log('Today is recognized by Rebecca Black!');
#});



#Sunday at 2:30pm:
#var j = schedule.scheduleJob({hour: 14, minute: 30, dayOfWeek: 0}, function(){
#console.log('Time for tea!');
#});

#https://github.com/node-schedule/node-schedule