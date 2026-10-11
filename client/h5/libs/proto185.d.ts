/** 矿石护送
 */
declare interface ProtoFmtInfo {
    18500: {
        desc: "通用错误返回";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    18501: {
        desc: "界面协议";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 第一公会会长服id */
            server_id: number;
            /** 服数 */
            server_num: number;
            /** 第一名公会id */
            guild_id: number;
            /**  公会名 */
            guild_name: string;
            /** 掠夺次数 */
            rob_times: number;
            /** 护送时长 */
            time: number;
        };
    };
    18502: {
        desc: "进入";
        send: (
            number: 18502,
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
            /** 返回码 */
            code: number;
        };
    };
    18503: {
        desc: "退出";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18504: {
        desc: "选择护送水晶类型";
        send: (number: 18504, fmt: "c", args: [type: number]) => never;
        sendFmt: "c";
        sendArgs: [type: number];
        recv: {
            /** 返回码 */
            code: number;
        };
    };
    18505: {
        desc: "排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 服数 */
                server_num: number;
                /** 服id */
                server_id: number;
                /**  公会名 */
                guild_name: string;
                /** 公会id */
                guild_id: number;
                /** 积分 */
                score: number;
                /** 排名 */
                rank: number;
            }[];
        };
    };
    18506: {
        desc: "护送列表(场景外)";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            list: {
                /** 服数 */
                server_num: number;
                /** 服id */
                server_id: number;
                /**  公会名 */
                guild_name: string;
                /** 公会id */
                guild_id: number;
                /** 护送类型 */
                escort_type: number;
                /** 场景 */
                scene: number;
            }[];
        };
    };
    18507: {
        desc: "公会内部排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            self_guild: {
                /** 职位 */
                position: number;
                /**  名字 */
                name: string;
                /** 玩家id */
                role_id: number;
                /** 积分 */
                score: number;
                /** 排名 */
                rank: number;
            }[];
            /** 护送结果  0未开始 1护送中 2失败 3普通 4完美 */
            escort_res: number;
            /** 护送类型 */
            escort_type: number;
            /** 护送获得积分 */
            add_score: number;
        };
    };
    18508: {
        desc: "护送列表(场景内)";
        send: (
            number: 18508,
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
            list: {
                /** 服数 */
                server_num: number;
                /** 服id */
                server_id: number;
                /**  公会名 */
                guild_name: string;
                /** 公会id */
                guild_id: number;
                /** 护送类型 */
                escort_type: number;
                /** 怪物唯一id */
                mon_auto_id: number;
                /** 场景坐标 */
                x: number;
                /** 场景坐标 */
                y: number;
                /** 场景 */
                scene: number;
                /** 血量 */
                hp: number;
                /** 血量上限 */
                hp_max: number;
            }[];
        };
    };
    18509: {
        desc: "通知公会成员";
        send: (
            number: 18509,
            fmt: "c",
            args: [
                /**1召集成员 2催促开车*/
                notify: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**1召集成员 2催促开车*/
            notify: number
        ];
        recv: null;
    };
    18510: {
        desc: "公会护送信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 护送类型 */
            escort_type: number;
            /** 护送结果  0未开始 1护送中 2失败 3普通 4完美 */
            escort_res: number;
        };
    };
    18511: {
        desc: "公会积分数据";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会总积分 */
            guild_score: number;
            /** 公会排名 */
            guild_rank: number;
        };
    };
    18512: {
        desc: "活动时间";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 开始时间 */
            start_time: number;
            /** 结束时间 */
            end_time: number;
        };
    };
    18513: {
        desc: "个人积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 个人掠夺积分 */
            rob_score: number;
            /** 掠夺次数 */
            rob_times: number;
            /** 护送时长 */
            time: number;
        };
    };
    18514: {
        desc: "奖励通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 奖励类型 1掠夺 2护送 */
            reward_type: number;
            reward: any;
            /** 掠夺积分护送积分 */
            score: number;
            /** 击杀积分 */
            kill_score: number;
        };
    };
}
