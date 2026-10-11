/** 花语鲜花周榜信息
 */
declare interface ProtoFmtInfo {
    22300: {
        desc: "错误码展示";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            code: number;
        };
    };
    22301: {
        desc: "赠送礼物";
        send: (
            number: 22301,
            fmt: "lhihc",
            args: [
                /**收礼玩家id*/
                receive_id: number,
                /**收礼者服务器id*/
                receive_server_id: number,
                /**礼物物品id*/
                goods_id: number,
                /**礼物数量*/
                goods_num: number,
                /**0: 不匿名 1: 匿名*/
                anonymous: number
            ]
        ) => never;
        sendFmt: "lhihc";
        sendArgs: [
            /**收礼玩家id*/
            receive_id: number,
            /**收礼者服务器id*/
            receive_server_id: number,
            /**礼物物品id*/
            goods_id: number,
            /**礼物数量*/
            goods_num: number,
            /**0: 不匿名 1: 匿名*/
            anonymous: number
        ];
        recv: {
            /** 返回码 */
            code: number;
            /** 收礼玩家id */
            receive_id: number;
            /** 收礼者服务器id */
            receive_server_id: number;
            /** 礼物物品id */
            goods_id: number;
            /** 礼物数量 */
            goods_num: number;
        };
    };
    22302: {
        desc: "收礼记录";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            record_list: {
                /** 记录id */
                id: number;
                /** 送礼玩家id */
                sender_id: number;
                /**  送礼玩家名字 */
                sender_name: string;
                server_id: number;
                server_num: number;
                /** 礼物物品id */
                goods_id: number;
                goods_num: number;
                /** 0: 不匿名 1: 匿名 */
                anonymous: number;
                /** 0 未感谢 1 已感谢 */
                is_thanks: number;
                /** 时间 */
                time: number;
            }[];
        };
    };
    22303: {
        desc: "鲜花相关信息";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 鲜花数 */
            flower_num: number;
            /** 魅力值 */
            charm: number;
            /** 名誉值 */
            fame: number;
        };
    };
    22304: {
        desc: "收到的鲜花通知";
        send: null;
        sendFmt: null;
        sendArgs: any;
        recv: {
            /** 送礼玩家id */
            sender_id: number;
            /** 玩家名字 */
            name: string;
            /** 性别 */
            sex: number;
            /** 阵营 */
            realm: number;
            /** 职业 */
            career: number;
            /** 等级 */
            level: number;
            /** 是否GM */
            GM: number;
            /** VIP */
            vip_flag: number;
            /** 职称 */
            touxian: number;
            /** 等级模型 */
            level_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                level_model_id: number;
            }[];
            /** 时装模型 */
            fashion_model_list: {
                /** 部位 */
                part_pos: number;
                /** 模型id */
                fashion_model_id: number;
                figure_chartlet_id: number;
            }[];
            /** 自定义头像url */
            picture: string;
            /** 自定义头像版本号 */
            prcture_ver: number;
            /** 帮派id */
            guild_id: number;
            /** 帮派名字 */
            guild_name: string;
            /** 帮派职位 */
            position: number;
            /** 帮派职位名字 */
            position_name: string;
            /** 称号 */
            dsgt_id: number;
            /** 活跃度形象Id */
            image_id: number;
            /** 转生次数 */
            turn: number;
            /** 转生阶段 */
            turn_stage: number;
            /** 爵位等级 */
            grade_id: number;
            /** 结婚状态 0单身 1情侣 2结婚 */
            is_marriage: number;
            /** 伴侣玩家id */
            marriage_id: number;
            /** 伴侣玩家name */
            marriage_name: string;
            /** 护送天使id */
            escort_state: number;
            /** 房子街区id */
            block_id: number;
            /** 房子id */
            house_id: number;
            /** 房子等级 */
            house_lv: number;
            /** 幻化模型 */
            figure_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 模型id */
                figure_id: number;
                figure_chartlet_id: number;
            }[];
            /** 幻化模型是否骑乘##找不到数据就默认骑乘 */
            figure_ride_list: {
                /** 类型 （1:坐骑 2：伙伴 3: 翅膀 4:神器 5：圣器 6：精灵 7：宠物） */
                figure_type: number;
                /** 是否骑乘(用于场景表现,点击头像等等忽略本字段) */
                is_ride: number;
            }[];
            /** 成就等级 */
            achv_lv: number;
            /** 勋章id */
            medal_id: number;
            /** 法阵id */
            fazhen_id: number;
            /** 装扮列表 */
            dress_list: {
                /** 装扮类型 */
                dress_type: number;
                /** 装扮id */
                dress_id: number;
            }[];
            /** 将神id */
            god_id: number;
            /** 天启套装 */
            revelation_suit: number;
            /** 使魔id */
            demon_id: number;
            /** 是否有至尊vip标识 */
            supreme_vip: number;
            /** 头衔id */
            title_id: number;
            /** 蒙面id */
            mask_id: number;
            /** 阵营四海争霸(玩家阵营) */
            seaCamp: number;
            /** 海战日常砖块品质 */
            brick_id: number;
            /** 假人类型（0:玩家） */
            dummy_type: number;
            /** 套装贴图id */
            suit_fashion_id: number;
            /** 采集状态 （0：非采集， 1：采集中） */
            collect_state: number;
            server_id: number;
            server_num: number;
            /** 赠送的物品 */
            goods_id: number;
            goods_num: number;
        };
    };
    22305: {
        desc: "感谢送花";
        send: (
            number: 22305,
            fmt: "l",
            args: [
                /**记录id*/
                id: number
            ]
        ) => never;
        sendFmt: "l";
        sendArgs: [
            /**记录id*/
            id: number
        ];
        recv: {
            code: number;
            /** 记录id */
            id: number;
        };
    };
}
