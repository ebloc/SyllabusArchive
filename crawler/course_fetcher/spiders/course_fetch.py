# -*- coding: utf-8 -*-
import scrapy
import re


class CourseFetchSpider(scrapy.Spider):
    name = 'course_fetch'
    allowed_domains = ['boun.edu.tr']
    start_urls = ['http://www.boun.edu.tr/en-US/Content/Academic/Undergraduate_Catalogue']
    semester = ''

    def __init__(self, semester='', **kwargs):
        # super().__init__(**kwargs)  # python3
        self.semester = semester

    def parse(self, response):
        for departmentUl in response.css('div.nonaccordion').css('ul'):
            for department in departmentUl.css('li').css('ul').css('li'):
                url = 'http://www.boun.edu.tr' + department.css('a').xpath('@href').extract()[0]
                yield scrapy.Request(url, self.gotoDepartment)

    def gotoDepartment(self, response):
        for courseInfo in response.xpath('//p/strong/text()').re(r'(^[A-Z]+ \d{3} .+\()'):
            courseCode = re.findall("^\w+ \d\d\d", courseInfo[:-1])[0].replace(" ", "")
            courseName = re.findall("\d .+", courseInfo)[0][1:].replace(":" , "").replace("(", "")
            RequestUrl = "http://registration.boun.edu.tr/scripts/instructor/coursedescriptions/" + self.semester + "/" + courseCode + "01.PDF"
            yield scrapy.Request(url=RequestUrl, callback=lambda response, courseName=courseName: self.savePdf(response, courseName) )

    def savePdf(self, response, courseName):
        try:
            if response.xpath('//b/b/b/text()').extract()[0] == "404 - File not found!":
                return
        except:
            pathSplit = response.url.split('/')
            path = "../../../syllabi/" + pathSplit[-2] + "_" + pathSplit[-1][:-6] + "_" + courseName + ".pdf"
            self.logger.info('Saving PDF %s', path)
            with open(path, 'wb') as f:
                f.write(response.body)
