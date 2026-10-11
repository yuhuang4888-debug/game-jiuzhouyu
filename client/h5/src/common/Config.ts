

export enum Config_Type {
    FilterAndMapped = 1,
    NoFilterButMapped = 2,
    FilterButNoMapped = 3,
    Nothing = 4 //全部生成 没有上面的所有规则
}
let local_Config_Type = Config_Type
window["Config_Type"] = Config_Type;
export class Config {
    //有设置默认值的配置项
    static ConfigHasDefaultValue = {
        ClientItemUse: { name: "ClientItemUse", config_type: local_Config_Type.FilterButNoMapped },
        config_goods: { name: "config_goods", config_type: local_Config_Type.NoFilterButMapped },
        config_mon: { name: "config_mon", config_type: local_Config_Type.NoFilterButMapped },
        config_dungeon_grade: { name: "config_dungeon_grade", config_type: local_Config_Type.NoFilterButMapped },
        config_equip_stren_lv: { name: "config_equip_stren_lv", config_type: local_Config_Type.NoFilterButMapped },
        config_star_map: { name: "config_star_map", config_type: local_Config_Type.NoFilterButMapped },
        config_achievement: { name: "config_achievement", config_type: local_Config_Type.NoFilterButMapped },
        config_dungeon: { name: "config_dungeon", config_type: local_Config_Type.NoFilterButMapped },
        config_task: { name: "config_task", config_type: local_Config_Type.NoFilterButMapped },
        config_gift_reward: { name: "config_gift_reward", config_type: local_Config_Type.NoFilterButMapped },
        config_rune_attr_num: { name: "config_rune_attr_num", config_type: local_Config_Type.NoFilterButMapped },
        config_decoration_level: { name: "config_decoration_level", config_type: local_Config_Type.NoFilterButMapped },
        config_equip_wash_attr: { name: "config_equip_wash_attr", config_type: local_Config_Type.NoFilterButMapped },
        config_baby_equip_stren: { name: "config_baby_equip_stren", config_type: local_Config_Type.NoFilterButMapped },
        config_equip_fusion: { name: "config_equip_fusion", config_type: local_Config_Type.NoFilterButMapped },
        config_equip_attr: { name: "config_equip_attr", config_type: local_Config_Type.NoFilterButMapped },
        config_gift_box: { name: "config_gift_box", config_type: local_Config_Type.NoFilterButMapped },
        config_dsgt_order: { name: "config_dsgt_order", config_type: local_Config_Type.NoFilterButMapped },
        config_mount_star: { name: "config_mount_star", config_type: local_Config_Type.NoFilterButMapped },
        config_pet_equip_pos_lv: { name: "config_pet_equip_pos_lv", config_type: local_Config_Type.NoFilterButMapped },
        config_pet_equip_star: { name: "config_pet_equip_star", config_type: local_Config_Type.NoFilterButMapped },
        config_pet_equip_stage: { name: "config_pet_equip_stage", config_type: local_Config_Type.NoFilterButMapped },
        config_companion_stage: { name: "config_companion_stage", config_type: local_Config_Type.NoFilterButMapped },
        config_goods_compose: { name: "config_goods_compose", config_type: local_Config_Type.NoFilterButMapped },
        config_goods_decompose: { name: "config_goods_decompose", config_type: local_Config_Type.NoFilterButMapped },
        config_revelation_equip_attr: { name: "config_revelation_equip_attr", config_type: local_Config_Type.NoFilterButMapped },
        config_dungeon_ui_content: { name: "config_dungeon_ui_content", config_type: local_Config_Type.NoFilterButMapped },
        config_boss_cfg: { name: "config_boss_cfg", config_type: local_Config_Type.NoFilterButMapped },
        config_eudemons_boss_cfg: { name: "config_eudemons_boss_cfg", config_type: local_Config_Type.NoFilterButMapped },
        config_dungeon_wave: { name: "config_dungeon_wave", config_type: local_Config_Type.NoFilterButMapped },
        config_enchantment_guard_boss: { name: "config_enchantment_guard_boss", config_type: local_Config_Type.NoFilterButMapped },
        config_skill_lv_data: { name: "config_skill_lv_data", config_type: local_Config_Type.FilterAndMapped },
        config_mount_level: { name: "config_mount_level", config_type: local_Config_Type.FilterAndMapped },
        config_kf_great_demon: { name: "config_kf_great_demon", config_type: local_Config_Type.NoFilterButMapped }
    };
    //进入登录页前必须先加载的客户端配置
    // static NECESSARY_CLIENT_CONFIG = {
    // ConfigLanguageMask : true,
    // ConfigLanguageMaskAlpha : true,
    // }
    //进入登录页前必须先加载的服务
    // static NECESSARY_SERVER_CONFIG = {
    // }
    //需要预加载的客户端配置,尽量只处理公共的配置，独立模块的通过ResManager的LoadGameConfig来加载
    static PRELOAD_CLIENT_CONFIG = {
        "ClientConfigDefaultVo": null,
        "ConfigOtherFightInfo": null,
        "ConfigCareerSkillMovies": null,
        "ConfigMonsterSkillMovies": null,
        "ConfigPartnerFightMovies": null,
        "ConfigGodSkillMovies": null,
        "ConfigClientScene": null,
        "ConfigNotNormalGoods": null,
        "ConfigFunctionIcon": null,
        "ConfigViewTween": null,
        "ConfigItemAttr": null,
        "ConfigFuncOpenCondition": null,
        "ConfigTaskArrow": null,
        "ConfigBoxIcon": null,
        "ClientItemUse": null,
        "ClientBlockConfig": null,
        "ConfigSkillUI": null,
        "ConfigRandomName": null,
        "ClientDoor": null,
        "ConfigHorse": null,
        "ConfigSceneObjHeight": null,
        "GoodsSourceConfig": null,
        "ConfigModelSpeed": null,
        "ConfigPartnerAwake": null,
        "ConfigTask": null,
        "ClientSceneModeCfg": null,
        "ConfigDragonBallMsg": null,
        "UIModelParameter": null,
        "ConfigCustomActivity": null,
        "ConfigInstruction": null,
        "ConfigTargetAutoFight": null,
        "ClientWorldMapConfig": null,
        "ClientTitleNameBordWidth": null,
        "ConfigSceneEffect": null,
        "ClientCustomActivityIconKey": null,
        "ConfigShaderObj": null,
        "SceneObjectParticle": null,
        "ConfigFuncOpenArrow": null,
        "MultiJumpPos": null,
        "ConfigDoorInSameScene": null,
        "ConfigSound": null,
        "ConfigModelAni": null,
        "ClientAchv": null,
        "ClientBanquet": null,
        "ClientNameVerifyConfig": null,
        "ClientFightCom": null,
        "ConfigKfHolyArena": null,
        "ClientMapConfig": null,
        "ClientOutWardModel": null,
        "ClientOutWardPos": null,
        "ConfigFirstRecharge": null,
        "ClientAttention": null,
        "ConfigDungeonClient": null,
        "ConfigKFuncIcon": null,
        "ClientDunWeekendMsg": null,
        "ClientDomainBoss": null,
        "ConfigTSCrack": null,
        "ClientRebirthEffect": null,
        "ClientReincarnationPos": null,
        "ClientBossBg": null,
        "ConfigBoss": null,
        "ConfigCompositeSource": null,
        "ConfigTaskJump": null,
        "ClientBuffShow": null,
        "ConfigUISkillEffectShow": null,
        "ConfigAutoBrush": null,
        "ClientConfigPopupLevel": null,
        "ClientOnHookInfo": null,
        "ClientRedBagOpen": null,
        "ConfigFuncFirstOpenArrow": null,
        "ClientRechargeShow":null,
        "ConfigIllusionModel":null,
        "ClientConfigCustomerService":null,
        "ConfigEyouAttention":null,
        "ConfigCompanionBiog":null,
        "ConfigRechargeEyouThProduct":null,
        "ConfigDailyFirstRecharge": null,
        "ConfigRechargeEyouEnProduct":null
    };

    //需要预加载的服务端配置,尽量只处理公共的配置，独立模块的通过ResManager的LoadGameConfig来加载
    static PRELOAD_SERVER_CONFIG = {
        "config_scene": null,
        "config_mon": null,
        "config_npc": null,
        "config_skill": null,
        "config_table_default": null,
        "config_picture": null,
        "config_key_value": null,
        "config_goods": null,
        "GoodsType": null,
        "config_equip_attr": null,
        "config_task": null,
        "config_goods_price": null,
        "config_appstroe_product": null,
        "config_onhook": null,
        "config_goods_exchange_rule": null,
        "config_reincarnation_cfg": null,
        "config_equip_pos2suittype": null,
        "config_rush_giftbag": null,
        "config_equip_strengthen_max": null,
        "config_task_sweep": null,
        "config_equip_fusion_attr": null,
        "config_equip_fusion": null,
        "config_dragon_ball": null,
        "config_talk": null,
        "config_attr_medicament": null,
        "config_attr_medicament_use_count": null,
        "GoodsSubtype": null,
        "config_equip_whole_reward": null,
        "config_goods_decompose": null,
        "config_dsgt": null,
        "config_dsgt_order": null,
        "config_companion": null,
        "config_god": null,
        "config_god_equip": null,
        "config_goods_compose": null,
        "config_optional_gift": null,
        "config_dress_up_cfg": null,
        "config_revelation_equip_attr": null,
        "config_revelation_equip_suit": null,
        "config_revelation_equip_figuire": null,
        "config_revelation_equip_gathering": null,
        "config_language_extra": null,
        "config_suit_clt": null,
        "config_dungeon_type": null,
        "config_temple_awaken": null,
        "config_temple_awaken_stage": null,
        "config_temple_awaken_kv": null,
        "config_temple_awaken_suit": null,
        "config_dungeon_learn_skill": null,
        "config_equip_stone_lv": null,
        "config_afk_kv": null,
        "config_god_equip_level": null,
        "config_achievement_category": null,
        "config_jjc_config": null,
        "config_wedding_candies": null,
        "config_wedding_guest_position": null,
        "config_sea_treasure_reward": null,
        "config_robot_chat_content": null,
        "config_occupy_name": null,
        "config_ac": null,
        "config_liveness_lv": null,
        "config_activity_liveness": null,
        "config_god_equip_cfg": null,
        "config_god_pos_limit": null,
        "config_equip_suit_item": null,
        "config_equip_suit_make": null,
        "config_fashion": null,
        "config_fashion_model": null,
        "config_fashion_pos": null,
        "config_fashion_color": null,
        "config_gfeast": null,
        "config_terri_mon": null,
        "config_terri_war_buff": null,
        "config_holy_spirit_battlefield_kv": null,
        "config_boss_cfg": null,
        "config_sanctuary_kv": null,
        "config_sanctuary_mon": null,
        "config_eternal_valley_chapter": null,
        "config_eternal_valley_stage": null,
        "config_investment_types": null,
        "config_investment_rewards": null,
        "config_investment_item": null,
        "config_c_sanctuary_camp": null,
        "config_c_sanctuary_type": null,
        "config_c_sanctuary_info": null,
        "config_c_sanctuary_mon": null,
        "config_c_sanctuary_mon_type": null,
        "config_c_sanctuary_score": null,
        "config_c_sanctuary_kv": null,
        "config_c_sanctuary_construction": null,
        "config_c_sanctuary_scene":null,
        "config_c_san_reward_preview": null,
        "config_dragon_star_up": null,
        "config_dragon_star_lv": null,
        "config_dragon_lv_up": null,
        "config_goods_sell_subtype": null,
        "config_marriage_constant": null,
        "config_ring_star": null,
        "config_flower_tools": null,
        "config_mon_pic_lv": null,
        "config_mon_pic": null,
        "config_midday_party_key_value": null,
        "config_mount_prop": null,
        "config_mount_skill": null,
        "config_mount_goods": null,
        "config_mount_stage": null,
        "config_mount_star": null,
        "config_mount_figure": null,
        "config_mount_figure_stage": null,
        "config_mount_figure_star": null,
        "config_companion_kv": null,
        "config_pet_equip_stage": null,
        "config_pet_equip_star": null,
        "config_pet_equip_goods": null,
        "config_pray": null,
        "config_reincarnation_task_cfg": null,
        "config_awakening_cell_cfg": null,
        "config_revelation_equip_skill": null,
        "config_rune_attr_num": null,
        "config_rune_attr_coefficient": null,
        "config_rune_wake_up": null,
        "config_treasure_hunt_task": null,
        "config_treasure_hunt": null,
        "config_mystery_shop_hit": null,
        "config_limit_shop_config": null,
        "config_skill_stren": null,
        "config_surprise_gift": null,
        "config_surprise_gift_draw": null,
        "config_surprise_gift_kv": null,
        "config_team_ui": null,
        "config_top_pk_key_value": null,
        "config_num_by_vip": null,
        "config_num_by_vip_info": null,
        "config_advertisement": null,
        "config_jjc_reward_break": null,
        "config_eudemons_item": null,
        "config_eudemons_equip_pos": null,
        "config_eudemons_equip_attr": null,
        "config_eudemons_strength": null,
        "config_guild_god_kv": null,
        "config_guild_god_lv": null,
        "config_guild_god": null,
        "config_guild_god_rune": null,
        "config_guild_god_rune_achievement": null,
        "config_guild_god_rune_combo": null,
        "config_guild_god_color": null,
        "config_guild_skill": null,
        "config_territory_mode": null,
        "config_mount_constant": null,
        "config_demons_value": null,
        "config_demons": null,
        "config_seal_pill": null,
        "config_seal_kv": null,
        "config_rune_pos": null,
        "config_companion_stage": null,
        "config_god_kv": null,
        "config_compose_menu": null,
        "config_ranking": null,
        "config_partner_dun_chapter": null,
        "config_drumwar_value": null,
        "config_mon_pic_group": null,
        "config_mon_pic_type": null,
        "config_recharge_product": null,
        "config_medal": null,
        "config_draconic_strong": null,
        "config_boss_type": null,
        "config_medal_stren_cost": null,
        "config_medal_stren_lv": null,
        "config_title_cfg": null,
        "config_armour_suit": null,
        "config_armour_equipment": null,
        "config_decoration_attr": null,
        "config_decoration_level_max": null,
        "config_decoration_level": null,
        "config_decoration_stage": null,
        "config_decoration_stage_max": null,
        "config_boss_type_key_value": null,
        "config_wx_kv": null,
        "config_rune_awake_skill": null,
        "config_res_act": null,
        "config_equip_stone_inlay": null,
        "config_equip_stone_pos_unlock": null,
        "config_domain_kill_reward": null,
        "config_module_open": null,
        "config_compose_menu_id": null,
        "config_decoration_kv": null,
        "config_constellation_equip": null,
        "config_equip_stren_lv_key": null,
        "config_equip_stren_lv": null,
        "config_spirit_rotary_kv": null,
        "config_demons_skill_add": null,
        "config_boss_show_hp": null,
        "config_dungeon_wave_helper": null,
        "config_magic_circle": null,
        "config_seal_equip": null,
        "config_seal_strong": null,
        "config_mystery_shop_good": null,
        "config_dungeon_ui_content": null,
        "config_dungeon_ui_tab": null,
        "config_god_court": null,
        "config_god_court_equip": null,
        "config_god_court_strength": null,
        "config_god_court_equip_stage": null,
        "config_week_dungeon": null,
        "config_week_dungeon_kv": null,
        "config_equip_stone_refine": null,
        "config_equip_stone_refine_goods": null,
        "config_equip_stone_refine_limit": null,
        "config_seacraft_daily_reward": null,
        "config_seacraft_ship": null,
        "config_sea_craft_daily_kv": null,
        "config_seacraft_kv": null,
        "config_draconic_equip": null,
        "config_treasure_hunt_reward": null,
        "config_rune_hunt_stage": null,
        "config_rune_hunt_turn_flush": null,
        "config_suit_clt_process": null,
        "config_top_pk_rank_reward": null,
        "config_top_pk_day_participate_reward": null,
        "config_drumwar_zone_reward": null,
        "config_drumwar_lv_to_zone": null,
        "config_drumwar_cfg": null,
        "config_week_dungeon_reward_view": null,
        "config_kf_1vn_time": null,
        "config_eudemons_boss_cfg": null,
        "config_eudemons_boss_exp": null,
        "config_eudemons_lv": null,
        "config_eudemons_boss_reward": null,
        "config_decoration_boss": null,
        "config_decoration_boss_kv": null,
        "config_constellation_page": null,
        "config_sanctum_reward_show": null,
        "config_sanctum_kv": null,
        "config_sanctum_scene_type": null,
        "config_chrono_rift_castle": null,
        "config_chrono_rift_castle_reward": null,
        "config_chrono_rift_castle_ratio": null,
        "config_task_stage_func_drop": null,
        "config_dungeon_rune_lv_data": null,
        "config_dungeon": null,
        "config_dungeon_wave": null,
        "config_dungeon_grade": null,
        "config_suit_clt_task": null,
        "config_chrono_rift_castle_kv": null,
        "config_territory": null,
        "config_terri_war_win_reward": null,
        "config_territory_kv": null,
        "config_territory_war_kv": null,
        "config_sea_treasure_mod": null,
        "config_sea_treasure_kv": null,
        "config_equip_wash": null,
        "config_equip_wash_unlock_lv": null,
        "config_equip_wash_attr": null,
        "config_rune_wake_up_lv": null,
        "config_rune_wake_up_exp": null,
        "config_dec_unlock_cell": null,
        "config_ring_stage": null,
        "config_mon_drop_rule": null,
        "config_special_drop": null,
        "config_wx_subscribe_temp": null,
        "config_dragon_language_boss_mon": null,
        "config_dragon_language_map": null,
        "config_gift_reward": null,
        "config_popup": null,
        "config_scene_chat_bubble": null,
        "config_scene_chat_bubble_kv": null,
        "config_rush_treasure_stage_reward": null,
        "config_rush_treasure_rank_reward": null,
        "config_welfare_cfg": null,
        "config_combat_welfare_reward": null,
        "config_goods_effect": null,
        "config_guild_battle_buff": null,
        "config_online_reward": null,
        "config_limit_tower_round": null,
        "config_enchantment_guard_boss": null,
        "config_enchantment_guard_stage_reward": null,
        "config_guild_constant": null,
        "config_enchantment_guard_soap_debris": null,
        "config_enchantment_guard_soap": null,
        "config_enchantment_guard_key_value": null,
        "config_push_gift_reward": null,
        "config_guild_assist": null,
        "config_fiesta_task": null,
        "config_fiesta_lv_exp": null,
        "config_night_ghost_boss": null,
        "config_night_ghost_reward": null,
        "config_night_ghost_kv": null,
        "config_mini_game_kv": null,
        "config_recharge_first":null,
        "config_fairy":null,
        "config_fairy_node":null,
        "config_banner_cfg":null,
        "config_gift_box":null,
        "config_rush_rank":null,
        "config_cycle_rank_info":null,
        "config_mount_level":null,
        "config_fashion_suit_star":null,
        "config_fashion_suit":null,
        "config_beings_gate_kv":null,
        "config_eudemons_cfg":null,
        "config_boss_first_blood_plus_boss":null,
        "config_dragon_ball_kv":null,
        "config_recharge_return":null,
        "config_dragon_ball_figure":null,
        "config_start_nuclear":null,
        "config_hero_halo":null,
        "config_recharge_direct_gift_gold":null,
        "config_kf_great_demon":null
    };
    static load_protocal_config_promise;
    static Enchantmentguardboss: any;
    static Supremevipskill: any;
    static Supremevipskillreplace: any;

    //获取配置项 有些可能需要加上默认值
    public static GetConfigVo(config_name: string, key: number | string, is_client_config = false, config_obj: any = null) {
        let cache_cfg = this.GetConfigFormOwnCache(config_name, key);
        if (cache_cfg) {
            return cache_cfg;
        }
        let cfg;
        if (config_obj == null) {
            if (is_client_config) {
                cfg = local_Config.PRELOAD_CLIENT_CONFIG[config_name];
                if (!cfg)
                    cfg = local_Config.PRELOAD_CLIENT_CONFIG[config_name];
            }
            else {
                cfg = local_Config.PRELOAD_SERVER_CONFIG[config_name];
                if (!cfg)
                    cfg = local_Config.PRELOAD_SERVER_CONFIG[config_name];
            }
        }
        else {
            cfg = config_obj;
        }
        if (cfg) {
            if (!this._cache_cfg_dic) {
                this._cache_cfg_dic = {};
            }
            if (!this._cache_cfg_dic[config_name]) {
                this._cache_cfg_dic[config_name] = {};
            }
            let vo = cfg[key], default_vo = local_Config.ConfigHasDefaultValue[config_name];
            this._cache_cfg_dic[config_name][key] = vo;
            if (!default_vo)
                return vo;
            let config_type = default_vo.config_type;
            if (config_type == local_Config_Type.Nothing) {
                return vo;
            }
            if (vo && vo.has_set_default_value == null) {
                default_vo = local_Config.GetConfigDefaultVo(config_name, is_client_config);
                if (default_vo) {
                    if (config_type == local_Config_Type.FilterAndMapped) {
                        let d_vo;
                        let new_vo = {};
                        for (let i = default_vo.length - 1; i >= 0; i--) {
                            d_vo = default_vo[i];
                            if (vo[i] == null) {
                                new_vo[d_vo.key] = d_vo.value;
                            }
                            else {
                                new_vo[d_vo.key] = vo[i];
                            }
                        }
                        vo = cfg[key] = new_vo;
                    }
                    else if (config_type == local_Config_Type.NoFilterButMapped) {
                        let new_vo = {};
                        for (let i = default_vo.length - 1; i >= 0; i--) {
                            new_vo[default_vo[i]] = vo[i];
                        }
                        vo = cfg[key] = new_vo;
                    }
                    else if (config_type == local_Config_Type.FilterButNoMapped) {
                        for (let key in default_vo) {
                            if (vo[key] == null) {
                                vo[key] = default_vo[key];
                            }
                        }
                    }
                }
                vo.has_set_default_value = true;
                this._cache_cfg_dic[config_name][key] = vo;
            }
            return vo;
        }
    }
    public static GetConfigKeyName(config_name: string, key: string | number) {
        let default_cfg = local_Config.PRELOAD_SERVER_CONFIG.config_table_default[config_name];
        let key_name = default_cfg[key];
        if (typeof key_name == "string") {
            return default_cfg;
        }
        else {
            return default_cfg.key;
        }
    }
    public static GetConfigIndex(config_name: string, key_name: string) {
        let vo = local_Config.ConfigHasDefaultValue[config_name];
        if (vo) {
            let config_type = vo.config_type;
            if (config_type == local_Config_Type.NoFilterButMapped) {
                let default_cfg: Array<string> = local_Config.PRELOAD_SERVER_CONFIG.config_table_default[config_name];
                return default_cfg.indexOf(key_name);
            }
            else {
                let default_cfg: Array<any> = local_Config.PRELOAD_SERVER_CONFIG.config_table_default[config_name];
                for (let i = 0; i < default_cfg.length; i++) {
                    if (key_name == default_cfg[i].key) {
                        return i;
                    }
                }
            }
        }
    }
    public static GetConfigDefaultVo(config_name: string, is_client_config = false) {
        let default_cfg;
        if (is_client_config) {
            default_cfg = local_Config.PRELOAD_CLIENT_CONFIG.ClientConfigDefaultVo[config_name];
        }
        else {
            default_cfg = local_Config.PRELOAD_SERVER_CONFIG.config_table_default[config_name];
        }
        return default_cfg;
    }
    private static _cache_cfg_dic;
    public static GetConfigFormOwnCache(cfg_name, key) {
        return this._cache_cfg_dic && this._cache_cfg_dic[cfg_name] && this._cache_cfg_dic[cfg_name][key];
    }
    public static GetConfigValue(cfg_name, key) {
    }
}
var local_Config = Config
window["Config1"] = Config //因为laya自带有Config对象，这里把laya的覆盖一下
window["Config"] = Config