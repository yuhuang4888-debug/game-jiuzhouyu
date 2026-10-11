/** 圣域
 */
declare interface ProtoFmtInfo {
    28300: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    28301: {
        desc: "列表信息";
        send: (
            number: 28301,
            fmt: "c",
            args: [
                /**圣域id*/
                sanctuary_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**圣域id*/
            sanctuary_id: number
        ];
        recv: {
            /** 圣域id */
            sanctuary_id: number;
            /** 当前领地积分 */
            point: number;
            /** 归属 */
            belong: number;
            /**  归属名称 */
            belong_name: string;
            /** 结束时间戳 */
            end_time: number;
            boss_info: {
                /** BossId */
                boss_id: number;
                /** 复活结束时间戳：0|>0 */
                reborn_time: number;
                /** 是否关注：0|1 */
                is_remind: number;
            }[];
        };
    };
    28302: {
        desc: "公会排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的公会排名 */
            my_guild_rank: number;
            /** 公会前十的平均战力 */
            my_guild_power_ten: number;
            rank_list: {
                /**  公会名字 */
                guild_name: string;
                /**  主席名字 */
                guild_chairman_name: string;
                /** 排名 */
                rank: number;
                /** 成员数 */
                menber_num: number;
                /** 成员上限 */
                all_num: number;
                /** 前十平均战斗力 */
                avg_power: number;
            }[];
        };
    };
    28303: {
        desc: "进入领地";
        send: (
            number: 28303,
            fmt: "c",
            args: [
                /**圣域id*/
                sanctuary_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**圣域id*/
            sanctuary_id: number
        ];
        recv: {
            /** 圣域id */
            sanctuary_id: number;
            /** 操作码 */
            code: number;
        };
    };
    28304: {
        desc: "退出领地";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    28305: {
        desc: "BOSS关注|取消关注操作";
        send: (
            number: 28305,
            fmt: "cic",
            args: [
                /**圣域id*/
                sanctuary_id: number,
                boss_id: number,
                /**是否关注  0|1 1是 0:否*/
                remind: number
            ]
        ) => never;
        sendFmt: "cic";
        sendArgs: [
            /**圣域id*/
            sanctuary_id: number,
            boss_id: number,
            /**是否关注  0|1 1是 0:否*/
            remind: number
        ];
        recv: {
            /** 圣域id */
            sanctuary_id: number;
            boss_id: number;
            remind: number;
        };
    };
    28306: {
        desc: "活动状态";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 活动结束时间戳 */
            end_time: number;
        };
    };
    28307: {
        desc: "BOSS重生提醒";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 圣地id */
            sanctuary_id: number;
            /** 怪物id */
            boss_id: number;
        };
    };
    28308: {
        desc: "玩家死亡信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 死亡次数 */
            die_times: number;
            /** 死亡等待结束时间 */
            time: number;
            /** debuff持续时间 */
            debuff_time: number;
            /** 玩家回安全区时间戳 */
            safe_time: number;
        };
    };
    28309: {
        desc: "boss被击杀信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 圣域id */
            sanctuary_id: number;
            /** 死亡等待结束时间 */
            boss_id: number;
            /** 复活时间戳 */
            reborn_time: number;
        };
    };
    28310: {
        desc: "公会成员内的排行榜";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 我的排名 */
            my_rank: number;
            /** 我的战力 */
            my_power: number;
            rank_list: {
                /** 玩家id */
                role_id: number;
                /** 排行 */
                rank: number;
                picture: string;
                picture_ver: number;
                /** 职业id */
                career: number;
                /** 玩家姓名 */
                role_name: string;
                /** 战力 */
                power: number;
                /** 称号id */
                desination: number;
            }[];
        };
    };
    28311: {
        desc: "BOSS击杀记录";
        send: (
            number: 28311,
            fmt: "ci",
            args: [
                /**圣域id*/
                sanctuary_id: number,
                /**bossId*/
                boss_id: number
            ]
        ) => never;
        sendFmt: "ci";
        sendArgs: [
            /**圣域id*/
            sanctuary_id: number,
            /**bossId*/
            boss_id: number
        ];
        recv: {
            /** 圣域id */
            sanctuary_id: number;
            /** bossId */
            boss_id: number;
            kill_log: {
                /** 击杀时间戳 */
                time: number;
                /**  击杀名字 */
                name: string;
                /** 1 显示积分  0 不显示积分 */
                is_show: number;
                /** 减少的积分 */
                reduce_point: number;
            }[];
        };
    };
    28312: {
        desc: "公会成员内的排行榜(关联圣域)";
        send: (
            number: 28312,
            fmt: "c",
            args: [
                /**圣域id*/
                sanctuary_id: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**圣域id*/
            sanctuary_id: number
        ];
        recv: {
            /** 圣域id */
            sanctuary_id: number;
            rank_list: {
                /** 排行 */
                rank: number;
                /** 玩家姓名 */
                role_name: string;
                /** 战力 */
                power: number;
                /** 称号id */
                desination: number;
            }[];
        };
    };
    28313: {
        desc: "己方怪物被攻击";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 圣地id */
            sanctuary_id: number;
            /** 怪物id */
            boss_id: number;
        };
    };
    28314: {
        desc: "上一次结算信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 公会排名 */
            guild_rank: number;
            /** 拥有圣域id */
            sanctuary_id: number;
            /** 个人排名 */
            person_rank: number;
            /** 称号id */
            desination_id: number;
        };
    };
    28315: {
        desc: "打开圣域界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    28316: {
        desc: "是否打开圣域界面后第一次打开";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 0:不是 1:是 */
            code: number;
        };
    };
    28317: {
        desc: "增加积分";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 增加的积分 */
            point: number;
        };
    };
    28318: {
        desc: "疲劳信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 疲劳 */
            fatigue: number;
        };
    };
    28319: {
        desc: "疲劳信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 疲劳 */
            fatigue: number;
        };
    };
}
