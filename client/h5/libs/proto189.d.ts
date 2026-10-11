/** 璀璨之海
 */
declare interface ProtoFmtInfo {
    18900: {
        desc: "主界面信息（所有玩家巡航数据）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /**  玩家上传的头像地址 */
            pic: string;
            /** 头像版本号 */
            pic_ver: number;
            /** 巡航次数 */
            reward_times: number;
            /** 巡航总次数 */
            total_reward_times: number;
            /** 掠夺次数 */
            rob_times: number;
            /** 掠夺总次数 */
            total_rob_times: number;
            /** 当前巡航唯一id 0表示什么没干 */
            auto_id: number;
            /** 巡航状态 0：巡航中 1：巡航完毕未领奖，2已领取 */
            status: number;
            /** 巡航列表 */
            send_list: {
                /** 唯一id */
                auto_id: number;
                /** 船只档次id */
                shipping_id: number;
                /** 服id */
                ser_id: number;
                /** 服数 */
                ser_num: number;
                /** 公会id */
                guild_id: number;
                /**  公会名 */
                guild_name: string;
                /** 玩家id */
                role_id: number;
                /**  玩家名 */
                role_name: string;
                /** 玩家等级 */
                role_lv: number;
                /** 玩家战力 */
                power: number;
                /** 性别 */
                sex: number;
                /** 职业 */
                career: number;
                /** 转生 */
                turn: number;
                /**  玩家上传的头像地址    假人和跨服玩家为空 */
                pic: string;
                /** 玩家上传的头像版本号  假人和跨服玩家为0 */
                pic_ver: number;
                /** 巡航结束时间 */
                end_time: number;
                /** 0未被掠夺1掠夺中或者已被掠夺 */
                rob_times: number;
            }[];
        };
    };
    18901: {
        desc: "玩家巡航日志";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            log_list: {
                /** 唯一id */
                auto_id: number;
                /** 0掠夺1被掠夺 */
                type: number;
                /** 服id((被)掠夺者) */
                rober_serid: number;
                /** 服数((被)掠夺者) */
                rober_sernum: number;
                /** 公会id((被)掠夺者) */
                rober_gid: number;
                /**  公会名((被)掠夺者) */
                rober_gname: string;
                /** 玩家id((被)掠夺者) */
                rober_id: number;
                /**  玩家名((被)掠夺者) */
                rober_name: string;
                /** 玩家战力((被)掠夺者) */
                rober_power: number;
                /** 船只档次id */
                shipping_id: number;
                reward: any;
                back_list: any;
                recv_list: any;
                /** 时间 */
                time: number;
            }[];
        };
    };
    18902: {
        desc: "船只界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前船只档次 */
            shipping_id: number;
            /** 当前船只档次幸运值 */
            luckey_value: number;
            /** 巡航次数 */
            reward_times: number;
            /** 巡航总次数 */
            total_reward_times: number;
            /** 每日免费升级使用次数 */
            up_times: number;
            /** 每日免费升级总次数 */
            total_up_times: number;
        };
    };
    18903: {
        desc: "开始巡航";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 船只档次 */
            shipping_id: number;
            /** 返回码 */
            code: number;
        };
    };
    18904: {
        desc: "巡航结束通知";
        send: (
            number: 18904,
            fmt: "l",
            args: [
                /**唯一id*/
                auto_id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**唯一id*/
            auto_id: number
        ];
        recv: {
            /** 唯一id */
            auto_id: number;
            /** 服id((被)掠夺者) */
            rober_serid: number;
            /** 服数((被)掠夺者) */
            rober_sernum: number;
            /** 玩家id((被)掠夺者) */
            rober_id: number;
            /**  玩家名((被)掠夺者) */
            rober_name: string;
            /** 玩家战力((被)掠夺者) */
            rober_power: number;
            /** 船只档次id */
            shipping_id: number;
            reward: any;
            rob_reward: any;
            /** 被掠夺时间 */
            time: number;
        };
    };
    18905: {
        desc: "开始掠夺/复仇";
        send: (
            number: 18905,
            fmt: "lilc",
            args: [
                /**船只唯一id*/
                auto_id: number,
                /**船只服id*/
                server_id: number,
                /**船只所属玩家id*/
                role_id: number,
                /**1掠夺 2复仇*/
                type: number
            ]
        ) => never;
        sendFmt: "lilc";
        sendArgs: [
            /**船只唯一id*/
            auto_id: number,
            /**船只服id*/
            server_id: number,
            /**船只所属玩家id*/
            role_id: number,
            /**1掠夺 2复仇*/
            type: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 船只唯一id */
            auto_id: number;
            /** 船只服id */
            server_id: number;
            /** 玩家id */
            role_id: number;
            /** 1掠夺 2复仇 */
            type: number;
        };
    };
    18906: {
        desc: "战斗开始预告";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 阶段 0还未进入 1即将开始 2正式开始 3退出阶段 */
            stage: number;
            /** 阶段结束时间戳 */
            time: number;
            /** 假人玩家镜像战力 阶段0才会有值，其他默认发0 */
            combat_power: number;
        };
    };
    18907: {
        desc: "战斗结果";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** aer 1胜利， aer 0失败 */
            res: number;
            /** 1掠夺 2复仇 */
            battle_type: number;
            /** 船只档次id */
            shipping_id: number;
            /** 船只唯一id */
            auto_id: number;
            /** 战斗发起方，真人 */
            aer: {
                /** 服数 */
                ser_num: number;
                /** 服id */
                ser_id: number;
                /**  玩家上传的头像地址 */
                pic: string;
                /** 玩家头像版本号 */
                pic_ver: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名 */
                name: string;
                /** 剩余血量百分比 0-100 */
                hp_per: number;
                /** 玩家战力 */
                power: number;
            }[];
            /** 假人镜像 */
            der: {
                /** 服数 */
                ser_num: number;
                /** 服id */
                ser_id: number;
                /** 性别 */
                sex: number;
                /** 职业 */
                career: number;
                /**  玩家上传的头像地址 假人和跨服玩家为空 */
                pic: string;
                /** 玩家上传的头像地址 假人和跨服玩家为0 */
                pic_ver: number;
                /** 转生 */
                turn: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名 */
                name: string;
                /** 剩余血量百分比 0-100 */
                hp_per: number;
                /** 玩家战力 */
                power: number;
            }[];
            /** 被协助玩家id */
            be_helper_id: number;
            reward: any;
        };
    };
    18908: {
        desc: "复仇成功通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 协助者id */
            role_id: number;
            /**  协助者名 */
            name: string;
            /**  协助者上传的头像地址 */
            pic: string;
            /** 协助者上传的头像版本号 */
            pic_ver: number;
            /** 船只档次（发0表示升船界面协议） */
            shipping_id: number;
            /** 船只唯一id */
            auto_id: number;
            reward: any;
            /** 加好友返回码1成功 其他失败 */
            add_friend_code: number;
        };
    };
    18909: {
        desc: "领取奖励";
        send: (
            number: 18909,
            fmt: "lc",
            args: [
                /**船只唯一id*/
                auto_id: number,
                /**2巡航奖励1掠夺奖励*/
                reward_type: number
            ]
        ) => never;
        sendFmt: "lc";
        sendArgs: [
            /**船只唯一id*/
            auto_id: number,
            /**2巡航奖励1掠夺奖励*/
            reward_type: number
        ];
        recv: {
            /** 唯一id */
            auto_id: number;
            /** 2巡航奖励1掠夺奖励 */
            reward_type: number;
            /** 档次id */
            shipping_id: number;
            /** 返回码 */
            code: number;
            reward: any;
        };
    };
    18910: {
        desc: "玩家巡航日志（新增）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            log_list: {
                /** 唯一id */
                auto_id: number;
                /** 0掠夺1被掠夺 */
                type: number;
                /** 服id((被)掠夺者) */
                rober_serid: number;
                /** 服数((被)掠夺者) */
                rober_sernum: number;
                /** 公会id((被)掠夺者) */
                rober_gid: number;
                /**  公会名((被)掠夺者) */
                rober_gname: string;
                /** 玩家id((被)掠夺者) */
                rober_id: number;
                /**  玩家名((被)掠夺者) */
                rober_name: string;
                /** 玩家战力((被)掠夺者) */
                rober_power: number;
                /** 船只档次id */
                shipping_id: number;
                reward: any;
                back_list: any;
                recv_list: any;
                /** 时间 */
                time: number;
            }[];
        };
    };
    18911: {
        desc: "玩家巡航船只（新增）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 巡航列表 */
            send_list: {
                /** 唯一id */
                auto_id: number;
                /** 船只档次id */
                shipping_id: number;
                /** 服id */
                ser_id: number;
                /** 服数 */
                ser_num: number;
                /** 公会id */
                guild_id: number;
                /**  公会名 */
                guild_name: string;
                /** 玩家id */
                role_id: number;
                /**  玩家名 */
                role_name: string;
                /** 玩家等级 */
                role_lv: number;
                /** 玩家战力 */
                power: number;
                /** 性别 */
                sex: number;
                /** 职业 */
                career: number;
                /** 转生 */
                turn: number;
                /**  玩家上传的头像地址    假人和跨服玩家为空 */
                pic: string;
                /** 玩家上传的头像版本号  假人和跨服玩家为0 */
                pic_ver: number;
                /** 巡航结束时间 */
                end_time: number;
                /** 0未被掠夺1掠夺中或者已被掠夺 */
                rob_times: number;
            }[];
        };
    };
    18912: {
        desc: "其他玩家协助成功通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 发1 玩家将被踢出 */
            code: number;
        };
    };
    18914: {
        desc: "船只界面";
        send: (
            number: 18914,
            fmt: "cc",
            args: [
                /**当前船只档次*/
                shipping_id: number,
                /**0否1是  一键神船（0的时候优先消耗免费次数升级）*/
                auto_up: number
            ]
        ) => never;
        sendFmt: "cc";
        sendArgs: [
            /**当前船只档次*/
            shipping_id: number,
            /**0否1是  一键神船（0的时候优先消耗免费次数升级）*/
            auto_up: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 当前船只档次 */
            shipping_id: number;
            /** 当前船只档次幸运值 */
            luckey_value: number;
            /** 每日免费升级使用次数 */
            up_times: number;
            /** 每日免费升级总次数 */
            total_up_times: number;
        };
    };
    18915: {
        desc: "跨服信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 跨服模式 */
            treasure_mod: number;
            /** 平均世界等级 */
            wlv: number;
            /** 当前对战服列表 */
            enemy: {
                /** 服id */
                ser_id: number;
                /** 服数 */
                ser_num: number;
                /**  服名 */
                ser_name: string;
                /** 服世界等级 */
                world_lv: number;
            }[];
            /** 不满足的跨服模式(开服天数满足世界等级不满足) */
            un_satisfy_mod: number;
            /** 不满足的平均世界等级(开服天数满足世界等级不满足) */
            un_satisfy_wlv: number;
            /** 需要最低世界等级 */
            min_wlv: number;
            /** 不满足的对战服列表（开服天数满足世界等级不满足） */
            un_satisfy: {
                /** 服id */
                ser_id: number;
                /** 服数 */
                ser_num: number;
                /**  服名 */
                ser_name: string;
                /** 服世界等级 */
                world_lv: number;
            }[];
        };
    };
    18916: {
        desc: "今日获得绑钻数量";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 数量 */
            num: number;
            /** 获取上限 */
            max: number;
        };
    };
    18917: {
        desc: "当前巡航状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前巡航唯一id 0表示什么没干 */
            auto_id: number;
            /** 巡航状态 0：巡航中 1：巡航完毕未领奖，2已领取 */
            status: number;
            /** 巡航次数 */
            reward_times: number;
            /** 巡航总次数 */
            total_reward_times: number;
        };
    };
    18918: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 1 */
            code: number;
        };
    };
    18919: {
        desc: "取消巡航结束可领取奖励通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            auto_id: number;
        };
    };
    18920: {
        desc: "错误码返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
}
