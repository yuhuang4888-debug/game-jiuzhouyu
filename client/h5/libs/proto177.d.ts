/** 家园
 */
declare interface ProtoFmtInfo {
    17701: {
        desc: "把家具放入身上（计算属性战力）";
        send: (
            number: 17701,
            fmt: "lh",
            args: [
                /**物品唯一id*/
                goods_id: number,
                /**放进去的数量*/
                put_num: number
            ]
        ) => never;
        sendFmt: "lh";
        sendArgs: [
            /**物品唯一id*/
            goods_id: number,
            /**放进去的数量*/
            put_num: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    17702: {
        desc: "打开小区选择界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 自己的小区id(若没有正在选择房子则为0，有的话请求17716) */
            own_block_id: number;
            /** 自己的房子id */
            own_house_id: number;
            /** 小区列表 */
            block_list: {
                /** 小区id */
                block_id: number;
                /** 房子数量 */
                house_num: number;
            }[];
        };
    };
    17703: {
        desc: "打开房子选择界面";
        send: (
            number: 17703,
            fmt: "i",
            args: [
                /**小区id*/
                block_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**小区id*/
            block_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子列表 */
            house_list: {
                /** 小区id */
                block_id: number;
                /** 房子id */
                house_id: number;
                /** 拥有者玩家id1 */
                role_id_1: number;
                /**  拥有者玩家1名字 */
                name1: string;
                /** 拥有者玩家id2 */
                role_id_2: number;
                /**  拥有者玩家2名字 */
                name2: string;
                /** 房子等级 */
                lv: number;
                /** 是否锁定 0否 1是 */
                lock: number;
                /** 购买时间 */
                buy_time: number;
                /**  留言 */
                text: string;
                /** 是否可选择 0不可选 1可选 */
                if_choose: number;
            }[];
        };
    };
    17704: {
        desc: "进入房子";
        send: (
            number: 17704,
            fmt: "ii",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 玩家id1 */
            role_id_1: number;
            /**  拥有者玩家1名字 */
            name1: string;
            /** 玩家id2 */
            role_id_2: number;
            /**  拥有者玩家1名字 */
            name2: string;
        };
    };
    17705: {
        desc: "离开房子";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    17706: {
        desc: "打开提升界面";
        send: (
            number: 17706,
            fmt: "ii",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            lv: number;
            /** 繁荣度 */
            point: number;
        };
    };
    17707: {
        desc: "提升房子/庭院";
        send: (
            number: 17707,
            fmt: "iicc",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number,
                /**类型：1自己付费 2AA*/
                type: number,
                /**1提升房子 2提升庭院*/
                apply_type: number
            ]
        ) => never;
        sendFmt: "iicc";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number,
            /**类型：1自己付费 2AA*/
            type: number,
            /**1提升房子 2提升庭院*/
            apply_type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 类型：1自己付费 2AA */
            type: number;
            /** 1提升房子 2提升庭院 */
            apply_type: number;
        };
    };
    17708: {
        desc: "购买房子";
        send: (
            number: 17708,
            fmt: "iic",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number,
                /**类型：1自己购买 2AA*/
                type: number
            ]
        ) => never;
        sendFmt: "iic";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number,
            /**类型：1自己购买 2AA*/
            type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 类型：1自己购买 2AA */
            type: number;
        };
    };
    17709: {
        desc: "通知另一个伴侣AA购买房子/升级/选择房子/升级庭院";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 玩家id */
            role_id: number;
            /** 类型：1买房子 2升级 3选择房子 4升级庭院 */
            type: number;
            /** 消耗列表（选择房子的时候为空） */
            cost_list: {
                goods_type: number;
                goods_type_id: number;
                goods_num: number;
            }[];
            /** 家具列表（选择房子的时候有） */
            furniture_inside_list: {
                goods_type_id: number;
            }[];
        };
    };
    17710: {
        desc: "回复AA购买房子/升级/选择房子/升级庭院";
        send: (
            number: 17710,
            fmt: "c",
            args: [
                /**类型：1同意 2不同意*/
                answer_type: number
            ]
        ) => never;
        sendFmt: "c";
        sendArgs: [
            /**类型：1同意 2不同意*/
            answer_type: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 类型：1买房子 2升级 3选择房子 4升级庭院 */
            type: number;
        };
    };
    17711: {
        desc: "收到回复AA购买房子/升级/选择房子/升级庭院";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 类型：1买房子 2升级 3选择房子 4升级庭院 */
            type: number;
            /** 类型：1同意 2不同意 */
            answer_type: number;
        };
    };
    17712: {
        desc: "确认查看回复";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
    17713: {
        desc: "把家具放进（移除）家园场景/移动家具";
        send: (
            number: 17713,
            fmt: "lichhccl",
            args: [
                /**家具位置唯一id（放进去为0）*/
                loc_id: number,
                /**物品类型id*/
                goods_type_id: number,
                /**1放进 2移除 3移动（更新）*/
                type: number,
                x: number,
                y: number,
                face: number,
                /**地图id 0地板，1左侧墙， 2右侧墙*/
                map_id: number,
                /**实例Id*/
                ins_id: number
            ]
        ) => never;
        sendFmt: "lichhccl";
        sendArgs: [
            /**家具位置唯一id（放进去为0）*/
            loc_id: number,
            /**物品类型id*/
            goods_type_id: number,
            /**1放进 2移除 3移动（更新）*/
            type: number,
            x: number,
            y: number,
            face: number,
            /**地图id 0地板，1左侧墙， 2右侧墙*/
            map_id: number,
            /**实例Id*/
            ins_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 新家具位置唯一id */
            new_loc_id: number;
            /** 物品类型id */
            goods_type_id: number;
            /** 1放进 2移除 3移动（更新） */
            type: number;
            /** 拥有者玩家id */
            role_id: number;
            x: number;
            y: number;
            face: number;
            /** 地图id 0地板，1左侧墙， 2右侧墙 */
            map_id: number;
            /** 实例Id */
            ins_id: number;
        };
    };
    17714: {
        desc: "场景里家具列表";
        send: (
            number: 17714,
            fmt: "ii",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            furniture_inside_list: {
                /** 家具位置唯一id */
                loc_id: number;
                /** 拥有者玩家id */
                role_id: number;
                /** 物品id */
                goods_type_id: number;
                x: number;
                y: number;
                face: number;
                /** 地图id 0地板，1左侧墙， 2右侧墙 */
                map_id: number;
            }[];
        };
    };
    17715: {
        desc: "登录请求玩家收到的aa请求和aa结果（返回17709177111774517747）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: null;
    };
    17716: {
        desc: "打开结婚后选择房子界面";
        send: (
            number: 17716,
            fmt: "ii",
            args: [block_id: number, house_id: number]
        ) => never;
        sendFmt: "ii";
        sendArgs: [block_id: number, house_id: number];
        recv: {
            errcode: number;
            /** 长度是2 */
            send_list: {
                block_id: number;
                house_id: number;
                house_lv: number;
                furniture_inside_list: {
                    goods_type_id: number;
                }[];
            }[];
        };
    };
    17717: {
        desc: "结婚后选择房子";
        send: (
            number: 17717,
            fmt: "ii",
            args: [block_id: number, house_id: number]
        ) => never;
        sendFmt: "ii";
        sendArgs: [block_id: number, house_id: number];
        recv: {
            errcode: number;
        };
    };
    17718: {
        desc: "通知场景玩家目標玩家家园信息改变（figure改變）";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 目标玩家 */
            role_id: number;
            block_id: number;
            house_id: number;
            house_lv: number;
            garden_lv: number;
        };
    };
    17719: {
        desc: "修改留言";
        send: (
            number: 17719,
            fmt: "iis",
            args: [block_id: number, house_id: number, text: string]
        ) => never;
        sendFmt: "iis";
        sendArgs: [block_id: number, house_id: number, text: string];
        recv: {
            errcode: number;
            block_id: number;
            house_id: number;
            text: string;
        };
    };
    17720: {
        desc: "查看家园里的家具列表";
        send: (
            number: 17720,
            fmt: "iihh",
            args: [
                block_id: number,
                house_id: number,
                /**主题id*/
                theme_id: number,
                /**家具类型*/
                furniture_type: number
            ]
        ) => never;
        sendFmt: "iihh";
        sendArgs: [
            block_id: number,
            house_id: number,
            /**主题id*/
            theme_id: number,
            /**家具类型*/
            furniture_type: number
        ];
        recv: {
            errcode: number;
            block_id: number;
            house_id: number;
            theme_id: number;
            furniture_type: number;
            furniture_list: {
                /** 物品id */
                goods_type_id: number;
                /** 数量 */
                num: number;
            }[];
        };
    };
    17721: {
        desc: "通知家园场景内玩家家园改变";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
            block_id: number;
            house_id: number;
            /** 1等级改变（家园17704 庭院17741） 2家具改变（请求17714） */
            type: number;
        };
    };
    17722: {
        desc: "获得推荐房子列表";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
            house_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /** 等级 */
                lv: number;
                block_id: number;
                house_id: number;
                house_lv: number;
            }[];
        };
    };
    17723: {
        desc: "打开家园送礼界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            house_gift_list: {
                /** 礼物id */
                gift_id: number;
                /** 已经送了的数量（不限次数的为零） */
                send_num: number;
            }[];
        };
    };
    17724: {
        desc: "进行家园送礼";
        send: (
            number: 17724,
            fmt: "iiis",
            args: [
                block_id: number,
                house_id: number,
                /**礼物id*/
                gift_id: number,
                /** 祝福语*/
                wish_word: string
            ]
        ) => never;
        sendFmt: "iiis";
        sendArgs: [
            block_id: number,
            house_id: number,
            /**礼物id*/
            gift_id: number,
            /** 祝福语*/
            wish_word: string
        ];
        recv: {
            errcode: number;
            block_id: number;
            house_id: number;
            /** 礼物id */
            gift_id: number;
        };
    };
    17725: {
        desc: "通知收到家园礼物";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            errcode: number;
        };
    };
    17726: {
        desc: "家园收礼记录";
        send: (
            number: 17726,
            fmt: "ii",
            args: [block_id: number, house_id: number]
        ) => never;
        sendFmt: "ii";
        sendArgs: [block_id: number, house_id: number];
        recv: {
            errcode: number;
            /** 人气值 */
            popularity: number;
            /** 送礼玩家信息列表 */
            gift_player_list: {
                /** 玩家id */
                role_id: number;
                /**  玩家名字 */
                role_name: string;
                /** 职业 */
                career: number;
                /** 性别 */
                sex: number;
                /** 转生次数 */
                turn: number;
                /** 等级 */
                lv: number;
                /** 礼物id */
                gift_id: number;
                /**  祝福语 */
                wish_word: string;
                /** 时间 */
                time: number;
            }[];
        };
    };
    17741: {
        desc: "进入庭院";
        send: (
            number: 17741,
            fmt: "ii",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 玩家id1 */
            role_id_1: number;
            /**  拥有者玩家1名字 */
            name1: string;
            /** 玩家id2 */
            role_id_2: number;
            /**  拥有者玩家1名字 */
            name2: string;
        };
    };
    17742: {
        desc: "打开提升界面";
        send: (
            number: 17742,
            fmt: "ii",
            args: [
                /**小区id*/
                block_id: number,
                /**房子id*/
                house_id: number
            ]
        ) => never;
        sendFmt: "ii";
        sendArgs: [
            /**小区id*/
            block_id: number,
            /**房子id*/
            house_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 小区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 庭院等级 */
            lv: number;
            /** 繁荣度 */
            point: number;
        };
    };
    17743: {
        desc: "打开产出功能界面";
        send: (
            number: 17743,
            fmt: "i",
            args: [
                /**特殊建筑id*/
                sp_building_id: number
            ]
        ) => never;
        sendFmt: "i";
        sendArgs: [
            /**特殊建筑id*/
            sp_building_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 特殊建筑id */
            sp_building_id: number;
            pos_list: {
                /** 槽位id */
                pos_id: number;
                /** 培养物品类型id */
                train_goods_type_id: number;
                /** 培养物品数量 */
                train_goods_num: number;
                /** 结束时间戳 */
                end_time: number;
            }[];
        };
    };
    17744: {
        desc: "放入产出物品";
        send: (
            number: 17744,
            fmt: "iih",
            args: [
                /**特殊建筑id*/
                sp_building_id: number,
                /**培养物品类型id*/
                train_goods_type_id: number,
                /**培养物品数量*/
                train_goods_num: number
            ]
        ) => never;
        sendFmt: "iih";
        sendArgs: [
            /**特殊建筑id*/
            sp_building_id: number,
            /**培养物品类型id*/
            train_goods_type_id: number,
            /**培养物品数量*/
            train_goods_num: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 特殊建筑id */
            sp_building_id: number;
            /** 槽位id */
            pos_id: number;
            /** 培养物品类型id */
            train_goods_type_id: number;
            /** 培养物品数量 */
            train_goods_num: number;
        };
    };
    17745: {
        desc: "回收产出物品";
        send: (
            number: 17745,
            fmt: "ic",
            args: [
                /**特殊建筑id*/
                sp_building_id: number,
                /**槽位id*/
                pos_id: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**特殊建筑id*/
            sp_building_id: number,
            /**槽位id*/
            pos_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 特殊建筑id */
            sp_building_id: number;
            /** 槽位id */
            pos_id: number;
        };
    };
    17746: {
        desc: "加速";
        send: (
            number: 17746,
            fmt: "ic",
            args: [
                /**特殊建筑id*/
                sp_building_id: number,
                /**槽位id*/
                pos_id: number
            ]
        ) => never;
        sendFmt: "ic";
        sendArgs: [
            /**特殊建筑id*/
            sp_building_id: number,
            /**槽位id*/
            pos_id: number
        ];
        recv: {
            /** 错误码 */
            errcode: number;
            /** 特殊建筑id */
            sp_building_id: number;
            /** 槽位id */
            pos_id: number;
        };
    };
    17747: {
        desc: "打开许愿池界面";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /** 当前许愿池id */
            wish_id: number;
            /** 是否可领当天免费许愿币 0否 1是 */
            if_get_daily_goods: number;
            /** 可领数量 */
            daily_goods_num: number;
        };
    };
    17748: {
        desc: "进行许愿";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
            /**  错误码替换 */
            str: string;
        };
    };
    17749: {
        desc: "领取许愿币";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 错误码 */
            errcode: number;
        };
    };
}
