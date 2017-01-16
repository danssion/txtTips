#数据库结构初版[待修改]
#用户信息表
CREATE TABLE `windforce_user` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`user_id` int(11) unsigned NOT NULL,#用户唯一id
	`token` varchar(255) NOT NULL,
	`did` varchar(255) NOT NULL DEFAULT '',#手机识别码
	`gender` tinyint(4) unsigned NOT NULL DEFAULT 0,
	`age` int(8) unsigned NOT NULL DEFAULT 0,
	`job` int(8) unsigned NOT NULL DEFAULT 0,
	`code` varchar(255) NOT NULL DEFAULT '',
	`code_status` tinyint(4) NOT NULL DEFAULT '',
	PRIMARY KEY (`id`),
	UNIQUE(`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

#队伍信息表
CREATE TABLE `windforce_team` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,#队伍ID
	`team_name` varchar(255) NOT NULL,#队伍名称
	`pic` varchar(255) NOT NULL, #队伍图片
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

#对战信息表[编辑维护] 默认遵循原则 id小的为a
CREATE TABLE `windforce_matchs` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,#比赛ID
	`team_a_id` int(11) unsigned NOT NULL,#对战队伍A
	`team_a_name` varchar(255) NOT NULL,#队伍A名字
	`team_b_id` int(11) unsigned NOT NULL,#对战队伍B
	`team_b_name` varchar(255) NOT NULL,#队伍B名字
	`match_time` int(11) unsigned NOT NULL, #比赛时间
	`status` tinyint(4) unsigned NOT NULL DEFAULT 0,#比赛结果状态 0/未又结果（通过时间对比确定是否在进行中) 1/A赢 2/B赢
	`level` tinyint(4) unsigned NOT NULL,#1/16强 2/8强 3/4强  4/半决赛 5/季军赛 6/冠军赛 
	`result` varchar(125) NOT NULL DEFAULT '',#结果比分
	`is_win` tinyint(4) NOT NULL DEFAULT 0,#是否为team_a赢 1/是 2/否
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

#竞猜券获取方式
CREATE TABLE `windforce_coupon` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,#获取途径ID
	`get_way` varchar(125) NOT NULL,#获取方式
	`max` smallint(8) unsigned NOT NULL,#最大获取量
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

#用户获得的竞猜券
CREATE TABLE `windforce_user_coupon` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,#竞猜券ID
	`user_id` int(11) unsigned NOT NULL,#用户唯一id
	`coupon_id` smallint(8) unsigned NOT NULL,#获取途径ID
	`coupon_content` varchar(255) NOT NULL DEFAULT '',#比赛猜想
	`status` tinyint(4) NOT NULL DEFAULT 0,#结果状态 0/未填写 1/已填写
	`add_time` int(11) unsigned NOT NULL, #获取时间
	`update_time` int(11) unsigned NOT NULL,#最后更新时间
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

#每日可竞猜的比赛[编辑维护]
CREATE TABLE `windforce_daily_match` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`match_id`  int(11) unsigned NOT NULL,#比赛ID
	`start_time` int(11) NOT NULL,#可被竞猜开始时间
	`end_time` int(11) NOT NULL,#可被竞猜结束时间
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

#每日竞猜
CREATE TABLE `windforce_daily_quiz` (
	`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`user_id` int(11) unsigned NOT NULL,#用户ID
	`match_id` int(11) unsigned NOT NULL,#比赛ID
	`time` int(11) unsigned NOT NULL,#竞猜时间
	`status` tinyint(4) unsigned NOT NULL,1/team_a赢 2/team_b赢
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;
