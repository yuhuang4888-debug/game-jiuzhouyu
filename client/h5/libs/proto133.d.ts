/** 结界守护
 */
declare interface ProtoFmtInfo {
    13300: {
        desc: "获取进入条件信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 当前野怪波数。 */
            current_times: number;
            /** 挑战需要波数 */
            need_times: number;
            /** 协助ID (不等于0代表交了协助) */
            assist_id: number;
            /** 协助者ID, 发起了请求且有人接受了才会有数据 */
            assister_id: number;
        };
    };
    13301: {
        desc: "排行榜信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 榜单类型：0 本服 ； 1 跨服 */
            rank_type: number;
            /** 角色当前排行 0为未上榜 */
            role_rank: number;
            /** 关卡 */
            level: number;
            /** 排行列表 */
            res: {
                /** 服务器ID */
                server_id: number;
                /** 服务器编号 */
                server_num: number;
                /** 角色ID */
                role_id: number;
                /** 名字 */
                role_name: string;
                /** 名次 */
                rank: number;
                /** 关卡 */
                level: number;
                /** 角色的战力 */
                combat: number;
            }[];
        };
    };
    13302: {
        desc: "封印之力信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 最大领取次数 */
            max_times: number;
            /** 当前领取次数 */
            current_times: number;
            /** 精魄消耗 */
            cost: number;
            /** 奖励列表 */
            reward_list: any;
        };
    };
    13303: {
        desc: "扫荡界面信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 当前扫荡次数 */
            current_times: number;
            /** 所得装备数量 */
            equip_num: number;
        };
    };
    13304: {
        desc: "扫荡";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 所得金币 */
            coin: number;
            /** 所得经验 */
            exp: number;
            /** 装备数量 */
            equip_num: number;
            /** 固定列表 */
            reward_list: any;
        };
    };
    13305: {
        desc: "进入退出副本吧";
        send: (
            number: 13305,
            fmt: "c",
            args: [
                /**0:进入     1：离开*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0:进入     1：离开*/
            type: number
        ];
        recv: {
            /** 错误码 */
            code: number;
        };
    };
    13306: {
        desc: "通关奖励信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 挑战状态  0:成功  1:挑战失败 */
            state: number;
            /** 所得金币 */
            coin: number;
            /** 所得经验 */
            exp: number;
            reward_array: {
                /** 0:通关奖励， 1：阶段奖励 */
                type: number;
                /** 奖励列表 */
                reward_list: {
                    /** 物品大类型 */
                    style: number;
                    /** 物品id */
                    typeId: number;
                    /** 数量 */
                    count: number;
                    /** 物品唯一id */
                    goods_id: number;
                }[];
            }[];
        };
    };
    13307: {
        desc: "开启关闭自动闯关";
        send: (
            number: 13307,
            fmt: "c",
            args: [
                /**0:开启     1：关闭*/
                type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**0:开启     1：关闭*/
            type: number
        ];
        recv: {
            /** 错误码 */
            code: number;
            /** 0:开启     1：关闭 */
            type: number;
        };
    };
    13308: {
        desc: "封印之力领取";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 奖励列表 */
            reward_list: any;
        };
    };
    13309: {
        desc: "下一个阶段奖励关卡";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 下个阶段奖励关卡 */
            next_stage_reward_gate: number;
        };
    };
    13310: {
        desc: "领取阶段奖励";
        send: (number: 13310, fmt: "l", args: [gate: number]) => never;
        sendFmt: "l";
        sendArgs: [gate: number];
        recv: {
            /** 错误码 */
            code: number;
            /** 奖励列表 */
            reward_list: any;
        };
    };
    13311: {
        desc: "下一关挂机收益";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            code: number;
            /** 金币 */
            gold: number;
            /** 经验 */
            exp: number;
        };
    };
    13320: {
        desc: "古宝相关已激活古宝列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 战力 */
            combat: number;
            soap_list: {
                /** 古宝ID */
                soap_id: number;
                /** 古宝碎片列表 */
                debris_list: {
                    /** 碎片ID */
                    debris_id: number;
                }[];
            }[];
        };
    };
    13321: {
        desc: "激活古宝碎片";
        send: (
            number: 13321,
            fmt: "hh",
            args: [
                /**古宝ID*/
                soap_id: number,
                /**碎片ID*/
                debris_id: number
            ]
        ) => never;
        sendFmt: "hh";
        sendArgs: [
            /**古宝ID*/
            soap_id: number,
            /**碎片ID*/
            debris_id: number
        ];
        recv: {
            errcode: number;
            /** 古宝ID */
            soap_id: number;
            /** 古宝碎片列表 */
            debris_list: {
                /** 碎片ID */
                debris_id: number;
            }[];
            /** 战力 */
            combat: number;
        };
    };
    13322: {
        desc: "查看结界守护新手流程节点信息";
        send: (number: 13322, fmt: "c", args: [node: number]) => never;
        sendFmt: "c";
        sendArgs: [node: number];
        recv: {
            node: number;
        };
    };
    13323: {
        desc: "获取结界守护新手流程节点信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            node: number;
        };
    };
    13324: {
        desc: "玩家请求协助次数信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 当日请求协助次数 */
            daily_ask_time: number;
            /** 下次请求时间 */
            next_ask_time: number;
        };
    };
}
