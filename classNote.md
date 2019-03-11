# 数据库课程设计

基于Oracle

## 第一阶段——需求分析

### 自上而下结构分析SA

### 数据流图

基本符号：
+ 箭头： 数据的流动
+ 圆或圆角矩形： 数据加工
+ 矩形： 实体
+ 侧边开口矩形： 存储

绘制步骤：
+ 画顶层数据流图
+ 画系统内部，即下层数据流图，分解可分解的结构，进行编号
+ 分解至不能再分解，得到最终的细化

注意：
+ 细化前后每部分的输入输出要一致，父子守恒
+ 数据流是依赖数据加工存在的，因此，存储与存储，实体与实体，实体与储存之间不存在直接的数据关联
+

### 数据字典
数据字典是数据的最小组成单位
包括： 数据项，数据结构，数据流，数据存储，处理过程等


## 第二阶段——概念结构设计
将需求分析得到的用户需求抽象为信息结构即概念模型的过程
常见四类方法：
+ 自顶向下
+ 自底向上  √本阶段常用方法
+ 逐步扩张
+ 混合策略

### E——R图
描述实体与关系模型，包含元素：
+ 菱形： 实体之间的连接关系
+ 矩形： 实体
+ 椭圆： 依赖实体的属性

其中属性有一些特殊用法，比如
+ 主属性：下划线
+ 派生属性： 计算所得，建表时不用，用虚线表示，
+ 可选属性： 括号
+ 多值属性： 同心圆

数据冗余与视图

为提高效率，允许保留部分冗余，但是要定义在视图中

## 第三阶段——逻辑结构设计
将概念结构转换为转化为DBMS
## 第四阶段——物理结构设计
## 第五阶段——实施
## 第六阶段——运行维护


# Oracle数据库
数据库与实例： 一个数据库可以建立多个实例（SID），一个实例可以在任何时候访问数据库

# SQL

## DDL

基本数据库对象： 表，视图，约束
创建:
```sql
create table 表名称（

字段1 数据类型 【default 默认值】，

字段2 数据类型  【default  默认值】

.......

字段3 数据类型  【default 默认值】

主键外键相关约束
）；

```

**主键、外键、唯一、检查这四项，既可以创建列约束，也可以创建表约束。而缺省 和 非空只能创建列约束。**

主键约束和唯一性约束的一个重要区别就是主键约束不能为空，而唯一性约束可以

删除：
```sql
drop table mytable;
```

更改：
```sql
1、增加列
  alter table SMS_LOG ADD SEND_ID NUMBER;
2、删除列
  ALTER TABLE users DROP COLUMN address;
3、修改字段类型
  alter table GROUP modify CREATOR_NO varchar2(50);
```

## DML
增删改查，其中查可以单独归类为DQL
增：
```sql
insert into a (id) values(4);        //表a后有选择字段，未选定的字段如果指定了default,则以default的值代替null
```

删：
```sql
delete from mytable where 1 = 1 ;
```

改
```sql
UPDATE 表名 SET 字段='XXX' WHERE 条件;
```

查
解析顺序

from->where->group by->having->select->order by

+ 聚合函数

+ 笛卡尔乘积

可以用逗号，也可以用CROSS join

+ 等值连接
使用等号作为连接条件
+ 非等值连接
使用where配合逻辑条件
+ 外连接

除了正常的left/right join,Oracle外连接还有一种独有的实现语法
```sql

select ename dno
from employee , my
where employee.empmp = my.empmp(+)  --带+的是副表，不带加号的是主表，主表全部显示，
```

Oracle支持全外连接  关键字是full join

+ 自然连接

省略连接条件，根据相同列属性（同名同类型）自动进行同类型连接

nature join

**注意自然连接的公共属性输出不允许限定表的归属**

比如对于emp，dept两个表都有的公共属性deptno，正常等值连接输出时需要限定emp.deptno 否则会混淆属性  ，
但是自然连接不允许加上表的归属，直接select deptno

+ using子句

代替属性相等的条件声明，要求查询必须是等值连接，且等连接中的列必须是同名，
form emp join dept
using(deptno)

+ 先过滤数据再连接，提高效率

+ 子查询

不相关子查询不依赖父查询数据,子查询语句可以单独运行

相关子查询依赖父查询数据，子查询语句不能单独运行，通常通过父表重命名在子查询里进行调用

查询每个部门低于平均工资的员工

```sql
select *
from emp e
where e.sal < (select avg(sal) from emp where deptno=e.deptno)



select *
from emp e
where exist (select count(*)
                from emp
                where emp.deptno=e.deptno
                having count(*)>3)
```

