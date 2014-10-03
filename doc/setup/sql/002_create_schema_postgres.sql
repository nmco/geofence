﻿set search_path to geofence;

-- CLEAN-UP
--drop table gf_gfuser cascade;
--drop table gf_rule_limits;
--drop table gf_layer_styles;
--drop table gf_layer_custom_props ;
--drop table gf_layer_attributes;
--drop table gf_layer_details;
--drop table gf_rule cascade;
--drop table gf_gsuser cascade;
--drop table gf_gsinstance cascade;
--drop table gf_user_usergroups;
--drop table gf_usergroup cascade;

--drop sequence hibernate_sequence;

-- TABLE CREATION
    create table gf_gfuser (
        id int8 not null,
        dateCreation timestamp,
        emailAddress varchar(255),
        enabled bool not null,
        extId varchar(255) unique,
        fullName varchar(255),
        name varchar(255) not null unique,
        password varchar(255),
        primary key (id)
    );

    create table gf_gsinstance (
        id int8 not null,
        baseURL varchar(255) not null,
        dateCreation timestamp,
        description varchar(255),
        name varchar(255) not null,
        password varchar(255) not null,
        username varchar(255) not null,
        primary key (id)
    );

    create table gf_gsuser (
        id int8 not null,
        admin bool not null,
        dateCreation timestamp,
        emailAddress varchar(255),
        enabled bool not null,
        extId varchar(255) unique,
        fullName varchar(255),
        name varchar(255) not null unique,
        password varchar(255),
        primary key (id)
    );

    create table gf_layer_attributes (
        details_id int8 not null,
        access_type varchar(255),
        data_type varchar(255),
        name varchar(255) not null,
        primary key (details_id, name),
        unique (details_id, name)
    );

    create table gf_layer_custom_props (
        details_id int8 not null,
        propvalue varchar(255),
        propkey varchar(255),
        primary key (details_id, propkey)
    );

    create table gf_layer_details (
        id int8 not null,
        area public.geometry,
        cqlFilterRead varchar(4000),
        cqlFilterWrite varchar(4000),
        defaultStyle varchar(255),
        type varchar(255),
        rule_id int8 not null,
        primary key (id),
        unique (rule_id)
    );

    create table gf_layer_styles (
        details_id int8 not null,
        styleName varchar(255)
    );

    create table gf_rule (
        id int8 not null,
        grant_type varchar(255) not null,
        layer varchar(255),
        priority int8 not null,
        request varchar(255),
        service varchar(255),
        workspace varchar(255),
        gsuser_id int8,
        instance_id int8,
        userGroup_id int8,
        primary key (id),
        unique (gsuser_id, userGroup_id, instance_id, service, request, workspace, layer)
    );

    create table gf_rule_limits (
        id int8 not null,
        area public.geometry,
        rule_id int8 not null,
        primary key (id),
        unique (rule_id)
    );

    create table gf_user_usergroups (
        user_id int8 not null,
        group_id int8 not null,
        primary key (user_id, group_id)
    );

    create table gf_usergroup (
        id int8 not null,
        dateCreation timestamp,
        enabled bool not null,
        extId varchar(255) unique,
        name varchar(255) not null unique,
        primary key (id)
    );

    create index idx_gsuser_name on gf_gsuser (name);

    alter table gf_layer_attributes
        add constraint fk_attribute_layer
        foreign key (details_id)
        references gf_layer_details;

    alter table gf_layer_custom_props
        add constraint fk_custom_layer
        foreign key (details_id)
        references gf_layer_details;

    alter table gf_layer_details
        add constraint fk_details_rule
        foreign key (rule_id)
        references gf_rule;

    alter table gf_layer_styles
        add constraint fk_styles_layer
        foreign key (details_id)
        references gf_layer_details;

    create index idx_rule_request on gf_rule (request);

    create index idx_rule_layer on gf_rule (layer);

    create index idx_rule_service on gf_rule (service);

    create index idx_rule_workspace on gf_rule (workspace);

    create index idx_rule_priority on gf_rule (priority);

    alter table gf_rule
        add constraint fk_rule_user
        foreign key (gsuser_id)
        references gf_gsuser;

    alter table gf_rule
        add constraint fk_rule_usergroup
        foreign key (userGroup_id)
        references gf_usergroup;

    alter table gf_rule
        add constraint fk_rule_instance
        foreign key (instance_id)
        references gf_gsinstance;

    alter table gf_rule_limits
        add constraint fk_limits_rule
        foreign key (rule_id)
        references gf_rule;

    alter table gf_user_usergroups
        add constraint fk_uug_user
        foreign key (user_id)
        references gf_gsuser;

    alter table gf_user_usergroups
        add constraint fk_uug_group
        foreign key (group_id)
        references gf_usergroup;

    create sequence hibernate_sequence;

--GRANTS
alter table gf_gfuser owner to geofence;
alter table gf_rule_limits owner to geofence;
alter table gf_layer_styles owner to geofence;
alter table gf_layer_custom_props owner to geofence;
alter table gf_layer_attributes owner to geofence;
alter table gf_layer_details owner to geofence;
alter table gf_rule owner to geofence;
alter table gf_gsuser owner to geofence;
alter table gf_gsinstance owner to geofence;
alter table gf_user_usergroups owner to geofence;
alter table gf_usergroup owner to geofence;

alter sequence hibernate_sequence owner to geofence;

--DEFAULTS
insert into geofence.gf_gfuser(id, datecreation, emailaddress, enabled, extid, fullname, "name", "password") values (0, 'now', null, true, 0, 'admin', 'admin', '21232f297a57a5a743894ae4a801fc3');