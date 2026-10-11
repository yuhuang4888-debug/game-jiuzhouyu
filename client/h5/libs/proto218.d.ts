/** 圣灵战场
 */
declare interface ProtoFmtInfo {
    21800: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            error_code: number;
        };
    };
    21801: {
        desc: "界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前模式  0 条件不足 1  本服  2： 2服模式  4：4服模式  8：8服模式 */
            mod: number;
            /** 0 关闭  1 等待  2 pk中 */
            status: number;
            /** 阶段结束时间    status == 0 ，则时间为0 */
            end_time: number;
            /** 下一个模式的服务器信息 */
            server_list: {
                server_id: number;
                server_num: number;
                c_server_msg: string;
                server_name: string;
                /** 世界等级 */
                lv: number;
            }[];
        };
    };
    21802: {
        desc: "进入场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    21803: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    21804: {
        desc: "经验变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 总经验 */
            all_exp: number;
        };
    };
    21805: {
        desc: "个人奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 积分 */
            point: number;
            reward_list: {
                /** 阶段 */
                stage: number;
                /** 0 不能领取 1 可以领取， 2已经领取 */
                status: number;
            }[];
        };
    };
    21806: {
        desc: "领取个人积分奖励";
        send: (
            number: 21806,
            fmt: "c",
            args: [
                /**阶段*/
                stage: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**阶段*/
            stage: number
        ];
        recv: {
            /** 奖励列表 */
            reward: any;
        };
    };
    21807: {
        desc: "玩家战场信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 积分 */
            point: number;
            /** 个人排名 */
            single_rank: number;
            /** 阵营排名 */
            group_rank: number;
            /** 怒气 */
            anger: number;
            /** 狂怒技能结束时间戳 */
            anger_end: number;
            /** buff列表 */
            buff_list: {
                attr_id: number;
                value: number;
            }[];
        };
    };
    21808: {
        desc: "战场统计";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            group_list: {
                /** 分组 */
                group_id: number;
                tower_num: number;
                /** 积分 */
                point: number;
                rank: number;
                role_list: {
                    role_id: number;
                    rank: number;
                    server_id: number;
                    server_num: number;
                    c_server_msg: string;
                    name: string;
                    point: number;
                    kill: number;
                    /** 助攻 */
                    assists: number;
                }[];
            }[];
        };
    };
    21809: {
        desc: "死亡信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            role_name: string;
            role_id: number;
            lv: number;
            power: number;
            picture_ver: number;
            picture: string;
            /** 怒气 */
            anger: number;
            server_id: number;
            career: number;
            turn: number;
        };
    };
    21810: {
        desc: "结算信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 输  1赢 */
            res: number;
            group_list: {
                group_id: number;
                tower_num: number;
                point: number;
            }[];
            my_group_id: number;
            my_rank: number;
        };
    };
    21811: {
        desc: "阶段发生变化";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0 关闭  1 等待  2 pk中 */
            status: number;
            /** 阶段结束时间    status == 0 ，则时间为0 */
            end_time: number;
        };
    };
    21812: {
        desc: "使用怒气技能";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    21813: {
        desc: "怪物信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 列表一般只有只有一条 */
            mon_list: {
                /** 怪物唯一id */
                mon_auto: number;
                /** 怪物配置id */
                mon_cfg_id: number;
                /** 当前血量 */
                hp: number;
                /** 总血量 */
                hp_all: number;
                /** 分组 */
                group_id: number;
            }[];
        };
    };
    21814: {
        desc: "怒气信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 怒气 */
            anger: number;
            /** 狂怒技能结束时间戳 */
            anger_end: number;
        };
    };
}
