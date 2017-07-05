package com.archsystemsinc.pqrs.controller;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.geojson.Feature;
import org.geojson.FeatureCollection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.archsystemsinc.pqrs.configuration.ReferenceDataLoader;
import com.archsystemsinc.pqrs.model.StatewiseStatistic;
import com.archsystemsinc.pqrs.repository.StatewiseStatisticRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * 
 * @author lekan reju
 * 
 * This class provides the data for Leaflet.
 *
 */
@RestController
public class MapDataController {

	static final String JAVASCRIPT = "application/javascript;charset=UTF-8"; 
	
	private ObjectMapper objectMapper;
	@Autowired
	private StatewiseStatisticRepository statewiseStatisticRepository;

	@Autowired
	private ReferenceDataLoader referenceDataLoader;
	
	public MapDataController() {
		super();
		objectMapper = new ObjectMapper();
	}

	/**
	 * 
	 * @param epOrGpro
	 * @param ruralOrUrban
	 * @param yesOrNoOption
	 * @param yearId
	 * @param reportingOptionId
	 * @return
	 * @throws JsonProcessingException
	 */
	@RequestMapping(method = RequestMethod.GET, produces = JAVASCRIPT, value = "/maps-data/epOrGpro/{epOrGpro}/ruralOrUrban/{ruralOrUrban}/yesOrNoOption/{yesOrNoOption}/year/{yearId}/reportingOption/{reportingOptionId}")
	public String findAllForMapsByRsql(
			 @PathVariable("epOrGpro") Integer epOrGpro, 
			 @PathVariable("ruralOrUrban") Integer ruralOrUrban, 
			 @PathVariable("yesOrNoOption") Integer yesOrNoOption, 
			 @PathVariable("yearId") Integer yearId,
			 @PathVariable("reportingOptionId") Integer reportingOptionId)
			throws JsonProcessingException {
		String attribute = ReferenceDataLoader.referenceData.get("reportingOptions").get(reportingOptionId);
		FeatureCollection featureCollection = new FeatureCollection();
		List<StatewiseStatistic> statewiseStatistics = statewiseStatisticRepository.getMapData(yearId, reportingOptionId, epOrGpro, ruralOrUrban, yesOrNoOption);
		for (StatewiseStatistic statewiseStatistic : statewiseStatistics) {
			Feature feature = new Feature();
			feature.setId(statewiseStatistic.getId()+"");
			BigInteger attributeValue = statewiseStatistic.getCount();
			Map<String, Object> properties = new HashMap<String, Object>();
			properties.put(attribute, attributeValue);
			properties.put("id", statewiseStatistic.getId());
			properties.put("State", statewiseStatistic.getState());
			feature.setProperties(properties);
			feature.setGeometry(ReferenceDataLoader.statesGeoData.get(statewiseStatistic.getState()));
			//feature.setGeometry(readGeoJSONUtil.findGeometryByState(statewiseStatistic.getState()));
			featureCollection.add(feature);
		}
		
		return "var data = "
				+ objectMapper.writeValueAsString(featureCollection);
	}
}
