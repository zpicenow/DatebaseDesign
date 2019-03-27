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

#### 集合查询

+ union： 只有相同类型的数据才能合并
+ intersect ： 交集
+ minus : 差集，去重
#### 琐碎关键字
+ dual

一个单行单列的表，充当一个占位表，使输出的有意义，保持输出结构平衡
+ sysdate ： 获取系统时间

#### 表间数据转换
```sql
insert into table1 select * from table2;
//如table1的字段为 id,name,value，而table2的字段为id,name
insert into table1 select id,name,null from table2;
//如table1的字段为 id,name,而table2的字段为id,name,value
insert into table1 select id,name from table2;

```

合并  merge : 备份，merge into后面是备份到的表，using后面是被备份的表


### 单行函数，多行函数
顾名思义，单行函数就是一行调用的函数，比如数字函数
多行函数就是多行语句，比如聚集函数

#### 数字函数
+ 四舍五入： round(原数，保留位数) from dual;
+ 首字母大写： initcap
保留位数为0就是保留整数，负数就是往整数部分保留（保留十位，百位等）；
+ 截断： truck（）只取到小数点后一位，只舍不入
+ 取模：mod（）
+ 大小写转换：upper（）大写，lower（）小写
+ 获取长度：length
+ 去掉空白：ltrim，rtrim，trim
+ 截取字符串： substr（str，begin，length）：begin为负数时，从后面数begin位，然后向后截取length，begin可省
+ 查找子串： instr(父串，子串，开始查找位置，第几次出现的位置)，最后两个参数可以省略
+　字符串填充：　LPAD（原字符串，预达到长度，填充字符），RPAD，L是左填充，R是右填充
#### 日期处理
+ last_day() ： 参数月份当月的最后一天
+ add_mouth():
+ next_day():
+ mouth_between()

#### 类型转换函数
+ to_char(): 数字转字符
+ to_number(): 字符转数字
+ to_date()/to_char()；字符和日期

to_date("2015-2月-12"，“YYYY-MM‘月’-DD”)
+ 显示转换与隐式转换
+ 钱的格式，to_char(sal,"L999,999.99");

L是本地金钱单位，￥或者$，后面数字是格式

+ decode情景查询，等值比较；case情景查询可以是区间段比较

decode(表达式 条件1，结果1，条件2，结果2，...缺省值)
case 表达式 when 条件 then 结果...end ： 只能是等值比较，如果区间段的话，select后面不加变量，变量在条件语句中体现


nvl(col,"xxx")

nvl2(col,"aaa","bbb")

nvl如果是col列非空就显示值，如果是空值就输出指定的xxx，nvl2如果非空就输出aaa，空值就输出bbb

+ 修改数据库系统时间 alter system；修改本数据实例时间alter session；

#### 层次查询
start with子句 ： 起始位置

connect by prior子句 ： 父子结点关系

```
select ename,empno,mgr,level
from emp
start with ename='KING'
connect with prior empno=mgr

```

从KING这个人开始找，找出empno等于前一个mgr的,level是对应层次

start with可以省略  ；如果省略的话，将每一条数据作为根节点查一遍；prior代表方向，上一级；
语句的逻辑是prior empno=mgr ： 上一级的empno等于mgr；
所以empno = prior mgr : 意思就是本次查询的empno等于下次查询的mgr

+ 翻译函数  translate

```sql
select translate('abcdggggggg','acd','123') from dual
//将字符串中的acd对！应！替换成123，因为acd不是子串，是不连续的，所以这是和replace的区别
//对于后两个参数长度不匹配时从前往后一一对应，
```

#### 分析查询

+ 开窗函数 over（）

用于分组之后，显示统计的结果是由哪些部分合成
括号里可以是order by或者partition by

```sql
select sum(sal),deptno  --empno,sal无法显示
from emp
group by deptno

select sum(sal) over(partition by deptno) ,empno,sal
from emp
group by deptno


select sum(sal)over(partition by deptno order by sal)empno,sal
from emp
group by deptno
//显示的的逐渐递增的过程，sumsal是逐渐累加的
```

+ rank（）等级，有并列的会加上 1,2,2,4
+ dense_rank()： 连续等级，有并列的不会加，1,2,2,3
+ first_value/last_value(): 显示查询出来的第一条数据的某个参数，附加到每一条查询数据中
+ row_number:


#### 数据类型

+ number: 不指定是32位，number(a,b):a代表全部位数，b代表小数位数，小数位数若为负数，就是小数点向左数的对应位数置零
+ Interger（n）：n位整数
+ varchar，varchar2：varchar固定长度，不够空格填充，varchar2不填充
+ char：固定长度字符
+ date，time：日期类型

#### 序列
```

create sequence name
    start with 1 //从1开始
    increment by 1      //每次增长1
    maxvalue 1000       // 最大值增长到多少
    minvalue 1          //最小值
    cache ()            //是否缓存


select name.nextvalue from dual
select name.currentvalue from dual
```

truncate table name  //截断表，清空数据，不可回滚