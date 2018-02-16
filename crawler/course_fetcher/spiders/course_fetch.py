# -*- coding: utf-8 -*-
import scrapy


class CourseFetchSpider(scrapy.Spider):
    name = 'course_fetch'
    allowed_domains = ['boun.edu.tr']
    start_urls = ['http://www.boun.edu.tr/en-US/Content/Academic/Undergraduate_Catalogue']
    file = open("output.txt", "w")

    def parse(self, response):
        for departmentUl in response.css('div.nonaccordion').css('ul'):
            for department in departmentUl.css('li').css('ul').css('li'):
                url = 'http://www.boun.edu.tr' + department.css('a').xpath('@href').extract()[0]
                print(url)
                yield scrapy.Request(url, self.gotoDepartment)

    def gotoDepartment(self, response):
        print(response.css('p').css('strong::text').extract())
        # self.file.write(response.css('p').css('strong::text')[0].extract())
    
    
