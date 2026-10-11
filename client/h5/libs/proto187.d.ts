/** 海域日常
 */
declare interface ProtoFmtInfo {
    18700: {
        desc: "通用错误码";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    18701: {
        desc: "界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            sea_list: {
                /** 海域id */
                sea_id: number;
                /** 雕像刷新时间 */
                statue_time: number;
                /** boss刷新时间 */
                boss_time: number;
                /** 砖块数量 */
                brick_num: number;
                /** 品质 */
                brick_color: number;
            }[];
        };
    };
    18702: {
        desc: "进入场景";
        send: (
            number: 18702,
            fmt: "c",
            args: [
                /**海域id--阵营id*/
                sea_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**海域id--阵营id*/
            sea_id: number
        ];
        recv: null;
    };
    18703: {
        desc: "场景信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            sea_id: number;
            /** 砖块数量 */
            brick_num: number;
            /** 搬运次数 */
            carry_count: number;
            /** 保卫次数 */
            defend_count: number;
            boss_list: {
                id: number;
                lv: number;
                name: string;
                reborn_time: number;
            }[];
        };
    };
    18704: {
        desc: "排行榜";
        send: (number: 18704, fmt: "c", args: [sea_id: number]) => never;
        sendFmt: "c";
        sendArgs: [sea_id: number];
        recv: {
            sea_id: number;
            /** 我的砖块数量 */
            my_num: number;
            my_rank: number;
            my_power: number;
            /** 职位 */
            my_pos: number;
            rank_list: {
                /** 职位 */
                pos: number;
                server_num: number;
                role_name: string;
                power: number;
                /** 砖块数量 */
                num: number;
            }[];
        };
    };
    18705: {
        desc: "开始搬砖";
        send: (number: 18705, fmt: "c", args: [sea_id: number]) => never;
        sendFmt: "c";
        sendArgs: [sea_id: number];
        recv: {
            code: number;
        };
    };
    18706: {
        desc: "卸下搬砖";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    18707: {
        desc: "升级砖块";
        send: (
            number: 18707,
            fmt: "c",
            args: [
                /**升级*/
                up_lv: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**升级*/
            up_lv: number
        ];
        recv: {
            /** 等级 */
            lv: number;
            code: number;
        };
    };
    18708: {
        desc: "退出场景";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    18709: {
        desc: "完成搬砖";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    18710: {
        desc: "搬砖奖励";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当前搬运次数 */
            carry_count: number;
            reward: any;
        };
    };
    18711: {
        desc: "全海域排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的砖块数量 */
            my_num: number;
            my_sea: number;
            my_rank: number;
            my_power: number;
            /** 职位 */
            my_pos: number;
            rank_list: {
                /** 所属海域 */
                sea_id: number;
                /** 职位 */
                pos: number;
                server_num: number;
                c_server_msg: string;
                role_name: string;
                power: number;
                /** 砖块数量 */
                num: number;
            }[];
        };
    };
    18712: {
        desc: "任务信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            task_list: {
                task_id: number;
                /** 完成次数 */
                count: number;
                /** 0 不可以领取 1 可以领取  2 已经领取 */
                status: number;
            }[];
        };
    };
    18713: {
        desc: "任务信息";
        send: (number: 18713, fmt: "c", args: [task_id: number]) => never;
        sendFmt: "c";
        sendArgs: [task_id: number];
        recv: {
            code: number;
            task_id: number;
            reward: any;
        };
    };
    18714: {
        desc: "封边被踢出场景通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 返回 1 */
            code: number;
        };
    };
    18715: {
        desc: "海域统治信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            sea_list: {
                sea_id: number;
                guild_id: number;
                guild_name: string;
            }[];
        };
    };
}
