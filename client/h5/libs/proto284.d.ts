/** 跨服圣域
 */
declare interface ProtoFmtInfo {
    28400: {
        desc: "界面协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 圣域模式 1简单 2普通 3困难 */
            san_type: number;
            server_ids: {
                /** 服务器id */
                server_id: number;
                /** 服务器数量 */
                server_num: number;
                /**  服务器名字 */
                server_name: string;
                /** 开服天数 */
                open_day: number;
                /** 初始出生点 */
                camp: number;
            }[];
        };
    };
    28401: {
        desc: "建筑信息";
        send: (
            number: 28401,
            fmt: "i",
            args: [
                /**场景id*/
                scene: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene: number
        ];
        recv: {
            /** 场景id */
            scene: number;
            /** 场景类型 */
            con_type: number;
            /** 归属阵营 无则发0 */
            bl_server: number;
            /** 上个归属阵营 */
            before_blserver: number;
            server: {
                /** 初始出生点 */
                camp: number;
                /** 跨服圣域积分 */
                score: number;
            }[];
            /** 建筑归属领取状态  0未达成 1已达成未领取 2已领取 */
            bl_reward_recieve: number;
            /** 本服参与人数 */
            person: number;
            boss_info: {
                /** bossid */
                bossid: number;
                /** 怪物类型 */
                mon_type: number;
                /** boss等级 */
                boss_lv: number;
                /** 复活时间戳 */
                reborn_time: number;
            }[];
        };
    };
    28403: {
        desc: "对应bossid的伤害排名";
        send: (
            number: 28403,
            fmt: "ii",
            args: [
                /**场景id*/
                scene: number,
                /**bossid*/
                bossid: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**场景id*/
            scene: number,
            /**bossid*/
            bossid: number
        ];
        recv: {
            /** bossid */
            bossid: number;
            rank_list: {
                /** 服务器id */
                server_id: number;
                /** 服务器数量 */
                server_num: number;
                /**  服务器名字 */
                server_name: string;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                name: string;
                /** 伤害百分比（0-10000） */
                hurt: number;
            }[];
        };
    };
    28404: {
        desc: "进入";
        send: (
            number: 28404,
            fmt: "i",
            args: [
                /**场景id*/
                scene: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene: number
        ];
        recv: {
            /** 返回码 1表示成功 */
            code: number;
        };
    };
    28405: {
        desc: "获取个人积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 个人积分 */
            score: number;
            /** 是否消耗过钻石解锁后面奖励 0否1是 */
            cost: number;
            /** 怒气值 */
            anger: number;
            score_reward: {
                /** 积分 */
                score_cfg: number;
                /** 0未达成 1已达成未领取 2已领取 */
                state: number;
            }[];
        };
    };
    28406: {
        desc: "解锁个人积分奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    28407: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    28408: {
        desc: "领取归属奖励";
        send: (
            number: 28408,
            fmt: "i",
            args: [
                /**场景id*/
                scene: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**场景id*/
            scene: number
        ];
        recv: {
            /** 场景id */
            scene: number;
            code: number;
        };
    };
    28409: {
        desc: "领取个人积分阶段奖励";
        send: (
            number: 28409,
            fmt: "i",
            args: [
                /**个人积分 （有奖励的积分点）*/
                score: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**个人积分 （有奖励的积分点）*/
            score: number
        ];
        recv: {
            /** 个人积分 （有奖励的积分点） */
            score: number;
            code: number;
        };
    };
    28410: {
        desc: "活动状态变化通知客户端";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开始时间 */
            act_start: number;
            /** %%% 整个活动结束时间戳 */
            act_end: number;
        };
    };
    28411: {
        desc: "占领建筑后推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            scene: number;
            /** 建筑类型 */
            con_type: number;
        };
    };
    28412: {
        desc: "击杀记录";
        send: (
            number: 28412,
            fmt: "ii",
            args: [
                /**场景id*/
                scene: number,
                /**怪物id*/
                monid: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**场景id*/
            scene: number,
            /**怪物id*/
            monid: number
        ];
        recv: {
            /** 场景id */
            scene: number;
            /** 怪物id */
            monid: number;
            pk_log: {
                /** 服务器id */
                server_id: number;
                /** 服务器数量 */
                server_num: number;
                c_server_msg: string;
                /** 玩家id（伤害最高玩家） */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 时间 */
                time: number;
            }[];
        };
    };
    28413: {
        desc: "boss刷新推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** boss刷新推送给所有玩家 */
            code: number;
        };
    };
    28414: {
        desc: "错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    28415: {
        desc: "死亡疲劳";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 死亡次数 */
            die_times: number;
            /** 死亡等待结束时间（可以免费复活） */
            time: number;
            /** debuff持续时间 */
            debuff_time: number;
            /** 玩家回安全区时间（搬运尸体） */
            safe_time: number;
        };
    };
    28416: {
        desc: "boss死亡通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** bossid */
            boss_id: number;
            /** 复活时间戳 */
            reborn_time: number;
        };
    };
    28417: {
        desc: "玩家踢出倒计时";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 踢出时间戳 */
            out_time: number;
        };
    };
    28418: {
        desc: "获得拍卖品时推送";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0要塞占领 1击杀boss */
            produce_type: number;
            /** 参与人数 */
            join_num: number;
            goods: {
                /** 物品类型id */
                goods_id: number;
                /** 数量 */
                num: number;
                /** 价格类型 1钻石 2绑钻 */
                gold_type: number;
                /** 价值 */
                worth: number;
            }[];
        };
    };
    28419: {
        desc: "排行";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 自己的排名 */
            self_rank: number;
            /** 自己的贡献值 */
            self_value: number;
            info: {
                /** 排名 */
                rank: number;
                /** 服数 */
                server_num: number;
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 总贡献 */
                total_point: number;
            }[];
        };
    };
    28420: {
        desc: "拍卖结束时间戳";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 结束时间戳 */
            end_time: number;
        };
    };
}
