CREATE TABLE IF NOT EXISTS `everyhour` (
	`id` bigint(11) NOT NULL AUTO_INCREMENT,
	`day` date NOT NULL,
	`hour` tinyint(3) NOT NULL DEFAULT '0',
	`consu_count` int(12) unsigned NOT NULL DEFAULT '0',
	`plt` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '客户端类型id 0=客户端 1=易览 2=网站 3=网站flash 4=无线   -1=all',
	`plt_count` int(10) unsigned NOT NULL DEFAULT '0',
	`posi` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '中播或者前播 2=中播 1=前播',
	`type` char(5) NOT NULL DEFAULT '-1' COMMENT '协商类型ABCD',
	`is_ie` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '是否是ie  0=老用户 1=本地 2=ie',
	`a_sz_sum` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '地域空间个数总数（20个 ）',
	`ads_sum` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '下发的广告数目（n个 ）',
	`u_12_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '跑够了12vv的用户',
	`area` varchar(80) NOT NULL DEFAULT '-1' COMMENT '地域',
	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

#每天数据按月生成表,月内数据自动分段
#consu
CREATE TABLE IF NOT EXISTS `every_day_年_月` (
	`id` bigint(11) NOT NULL AUTO_INCREMENT,#主键id
	`day` date NOT NULL,
	`plt` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '客户端类型 -1/all 0/客户端 1/易览　2/网站 3/网站flash 4/无线',
	`type` char(5) NOT NULL DEFAULT '-1' COMMENT '协商类型ABCD -1/全部',
	`posi` int(10) NOT NULL DEFAULT '-1' COMMENT '1/前播 2中播',
	`is_ie` tinyint(3) NOT NULL DEFAULT '-1' COMMENT ' 0=老用户 1=本地 2=ie',
	`area` varchar(80) NOT NULL DEFAULT '-1' COMMENT '地域',
	`is_dpl` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '是否启用dpl 是否是多普勒 1=dpl 0=not',
	`e_exc` tinyint(3) NOT NULL DEFAULT '-1' COMMENT 'e_exc值',
	`log_type_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'log_type总数',
	`plt_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'plt总数',
	`is_ie_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'is_ie总数',
	`is_dpl_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'is_dpl总数',
	`type_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'type总数',
	`posi_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'posi总数',
	`apc_clear_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'apc_clear总数',
	`e_sk_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'e_sk总数',
	`e_na_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'e_na_a总数',
	`e_ct_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'e_ct总数',
	`e_exc_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'e_exc总数',
	`mgs_id` varchar(40) NOT NULL DEFAULT '-1' COMMENT '媒介组id',
	`mgs_a` bigint(11)  NOT NULL DEFAULT 0 COMMENT '媒介组id对应的数量',
	`a_ags_id` varchar(40) NOT NULL DEFAULT '-1' COMMENT '地域组id',
	`a_ags_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '地域组id对应的数量',
	`a_sz_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '地域空间个数',
	`a_cpre_s` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'a_cpre平均值',
	`a_dpl` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '地域dpl开关　1/开 2关',
	`a_dpl_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'a_dpl总数',
	`a_2pv` tinyint(3) NOT NULL DEFAULT '-1' COMMENT '２次报数是否开启　1/开 2关',
	`a_2pv_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'a_2pv总数',
	`a_mT_s` decimal(10,2) NOT NULL DEFAULT 0 COMMENT 'a_mT均值',
	`co_sum1_s` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'co_sum1均值',
	`co_sum2_s` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'co_sum2均值',
	`d_con_s` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'd_con均值',
	`ad_id` varchar(40) NOT NULL DEFAULT '-1' COMMENT '广告id',
	`m_id` varchar(40) NOT NULL DEFAULT '-1' COMMENT '物料id',
	`ad_dd_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '打底广告id对应的数量',
	`u_cl_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'u_cl总数',
	`u_lo_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'u_lo总数',
	`u_12_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'u_12总数',
	`dplc_s` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '广告id对应的均值',
	`r_uid_u` bigint(11) NOT NULL DEFAULT 0 COMMENT '机器唯一id去重数',
	`mid_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '物料id对应的数据',
	`hyid_u` bigint(11) NOT NULL DEFAULT 0 COMMENT '后裔cookie去重总数',
	`ads_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '下发广告数',
	`sps_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '下发广告空间总值',
	PRIMARY KEY (`id`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  partition by hash(DAY(`day`)) partitions 31;


#count
CREATE  TABLE IF NOT EXISTS `every_day_年＿月` (
	`id` bigint(11) NOT NULL AUTO_INCREMENT,#主键id
	`day` date NOT NULL,
	`area` varchar(80) NOT NULL DEFAULT '-1' COMMENT '地域',
	`type` char(5) NOT NULL DEFAULT '-1' COMMENT '协商类型ABCD -1/全部',
	`posi` int(10) NOT NULL DEFAULT '-1' COMMENT '1/前播 2中播',
	`ad_id` varchar(40) NOT NULL DEFAULT '-1' COMMENT '广告id',
	`log_type_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'log_type总数',
	`type_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'type总数',
	`r_uid_u` bigint(11) NOT NULL DEFAULT 0 COMMENT '机器唯一id去重数',
	`posi_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'posi总数',
	`e_t_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '超时退出个数',
	`id_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '展现广告计数',
	`ad_count_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '展现广告　总计数',
	`hyid_u` bigint(11) NOT NULL DEFAULT 0 COMMENT '后裔cookie去重总数',
	PRIMARY KEY (`id`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  partition by hash(DAY(`day`)) partitions 31;

#click
CREATE  TABLE IF NOT EXISTS `every_day_年_月` (
	`id` bigint(11) NOT NULL AUTO_INCREMENT,#主键id
	`day` date NOT NULL,
	`area` varchar(80) NOT NULL DEFAULT '-1' COMMENT '地域',
	`type` char(5) NOT NULL DEFAULT '-1' COMMENT '协商类型ABCD -1/全部',
	`ad_id` varchar(40) NOT NULL DEFAULT '-1' COMMENT '广告id',
	`log_type_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'log_type总数',
	`type_a` bigint(11) NOT NULL DEFAULT 0 COMMENT 'type总数',
	`r_uid_u` bigint(11) NOT NULL DEFAULT 0 COMMENT '机器唯一id去重数',
	`e_t_a` bigint(11) NOT NULL DEFAULT 0 COMMENT '超时退出个数',
	`hyid_u` bigint(11) NOT NULL DEFAULT 0 COMMENT '后裔cookie去重总数',
	PRIMARY KEY (`id`,`day`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8  partition by hash(DAY(`day`)) partitions 31;
